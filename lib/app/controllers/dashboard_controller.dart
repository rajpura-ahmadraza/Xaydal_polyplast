import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/customer_model.dart';

class DashboardController extends GetxController {
  final _box = GetStorage();

  // Reactive state
  final products = <ProductModel>[].obs;
  final orders = <OrderModel>[].obs;
  final customers = <CustomerModel>[].obs;

  // Computed getters
  double get todayEarning {
    final today = DateTime.now();
    return orders
        .where((o) =>
            o.status == 'delivered' &&
            o.date.day == today.day &&
            o.date.month == today.month &&
            o.date.year == today.year)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get monthlyEarning {
    final now = DateTime.now();
    return orders
        .where((o) =>
            o.status == 'delivered' &&
            o.date.month == now.month &&
            o.date.year == now.year)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  int get pendingOrdersCount =>
      orders.where((o) => o.status == 'pending').length;

  List<OrderModel> get recentOrders =>
      orders.reversed.take(5).toList();

  List<ProductModel> get lowStockProducts =>
      products.where((p) => p.isLowStock).toList();

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Load Products
    final savedProducts = _box.read('products');
    if (savedProducts != null) {
      products.assignAll(
        (jsonDecode(savedProducts) as List)
            .map((e) => ProductModel.fromJson(e))
            .toList(),
      );
    } else {
      _loadDefaultProducts();
    }

    // Load Orders
    final savedOrders = _box.read('orders');
    if (savedOrders != null) {
      orders.assignAll(
        (jsonDecode(savedOrders) as List)
            .map((e) => OrderModel.fromJson(e))
            .toList(),
      );
    } else {
      _loadDefaultOrders();
    }

    // Load Customers
    final savedCustomers = _box.read('customers');
    if (savedCustomers != null) {
      customers.assignAll(
        (jsonDecode(savedCustomers) as List)
            .map((e) => CustomerModel.fromJson(e))
            .toList(),
      );
    } else {
      _loadDefaultCustomers();
    }
  }

  void _loadDefaultProducts() {
    products.assignAll([
      ProductModel(id: 'p1', name: '5L Plastic Bucket', price: 45, stock: 120, size: '5L', color: 'Blue'),
      ProductModel(id: 'p2', name: '10L Plastic Bucket', price: 75, stock: 85, size: '10L', color: 'Red'),
      ProductModel(id: 'p3', name: '20L Plastic Bucket', price: 120, stock: 18, size: '20L', color: 'Green', minStock: 30),
      ProductModel(id: 'p4', name: '5L Painted Bucket', price: 60, stock: 50, size: '5L', color: 'Yellow'),
    ]);
    _saveProducts();
  }

  void _loadDefaultOrders() {
    final now = DateTime.now();
    orders.assignAll([
      OrderModel(id: 'o1', customerName: 'Ramesh Shah', customerPhone: '9876543210',
          productId: 'p2', productName: '10L Plastic Bucket', quantity: 30,
          pricePerUnit: 75, totalAmount: 2250, status: 'pending', date: now),
      OrderModel(id: 'o2', customerName: 'Priya Store', customerPhone: '9123456789',
          productId: 'p3', productName: '20L Plastic Bucket', quantity: 15,
          pricePerUnit: 120, totalAmount: 1800, status: 'pending',
          date: now.add(const Duration(days: 1))),
      OrderModel(id: 'o3', customerName: 'Mohan Traders', customerPhone: '9988776655',
          productId: 'p1', productName: '5L Plastic Bucket', quantity: 50,
          pricePerUnit: 45, totalAmount: 2250, status: 'delivered',
          date: now.subtract(const Duration(days: 1))),
    ]);
    _saveOrders();
  }

  void _loadDefaultCustomers() {
    customers.assignAll([
      CustomerModel(id: 'c1', name: 'Ramesh Shah', phone: '9876543210',
          address: 'Himatnagar', totalPurchase: 18500, totalOrders: 12,
          createdAt: DateTime.now()),
      CustomerModel(id: 'c2', name: 'Priya Store', phone: '9123456789',
          address: 'Gandhinagar', totalPurchase: 12200, totalOrders: 8,
          createdAt: DateTime.now()),
      CustomerModel(id: 'c3', name: 'Mohan Traders', phone: '9988776655',
          address: 'Ahmedabad', totalPurchase: 9800, totalOrders: 6,
          createdAt: DateTime.now()),
    ]);
    _saveCustomers();
  }

  // ─── Product Methods ───────────────────────────────────────────
  void addProduct(ProductModel p) {
    products.add(p);
    _saveProducts();
    Get.snackbar('સફળ!', '${p.name} ઉમેરવામાં આવ્યો', snackPosition: SnackPosition.BOTTOM);
  }

  void updateStock(String productId, int qty) {
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      products[idx].stock += qty;
      products.refresh();
      _saveProducts();
      Get.snackbar('Stock અપડેટ', '${products[idx].name}: ${products[idx].stock} pcs',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _saveProducts() {
    _box.write('products', jsonEncode(products.map((p) => p.toJson()).toList()));
  }

  // ─── Order Methods ─────────────────────────────────────────────
  void addOrder(OrderModel o) {
    // Reduce stock
    final idx = products.indexWhere((p) => p.id == o.productId);
    if (idx != -1) {
      if (products[idx].stock < o.quantity) {
        Get.snackbar('Error', 'Stock ઓછો છે! Available: ${products[idx].stock}',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      products[idx].stock -= o.quantity;
      products.refresh();
      _saveProducts();
    }
    orders.add(o);
    _saveOrders();

    // Update customer totals
    final cIdx = customers.indexWhere((c) => c.phone == o.customerPhone);
    if (cIdx != -1) {
      customers[cIdx].totalOrders++;
      customers[cIdx].totalPurchase += o.totalAmount;
      customers.refresh();
      _saveCustomers();
    }

    Get.snackbar('ઓર્ડર ઉમેરાયો!', '${o.customerName} - ₹${o.totalAmount.toInt()}',
        snackPosition: SnackPosition.BOTTOM);
  }

  void markOrderDelivered(String orderId) {
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      orders[idx].status = 'delivered';
      orders.refresh();
      _saveOrders();
      Get.snackbar('ડિલિવર!', '${orders[idx].customerName} - ₹${orders[idx].totalAmount.toInt()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _saveOrders() {
    _box.write('orders', jsonEncode(orders.map((o) => o.toJson()).toList()));
  }

  // ─── Customer Methods ──────────────────────────────────────────
  void addCustomer(CustomerModel c) {
    customers.add(c);
    _saveCustomers();
    Get.snackbar('ગ્રાહક ઉમેરાયો!', c.name, snackPosition: SnackPosition.BOTTOM);
  }

  void _saveCustomers() {
    _box.write('customers', jsonEncode(customers.map((c) => c.toJson()).toList()));
  }
}
