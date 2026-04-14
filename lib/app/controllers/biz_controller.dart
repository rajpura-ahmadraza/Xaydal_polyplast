import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/models.dart';

class BizController extends GetxController {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final products  = <ProductModel>[].obs;
  final orders    = <OrderModel>[].obs;
  final customers = <CustomerModel>[].obs;

  final isLoadingProducts  = true.obs;
  final isLoadingOrders    = true.obs;
  final isLoadingCustomers = true.obs;

  String get uid => _auth.currentUser?.uid ?? '';

  // ── Computed ────────────────────────────────────────────────
  double get todayEarning {
    final t = DateTime.now();
    return orders.where((o) => o.status == 'delivered' &&
        o.date.year == t.year && o.date.month == t.month && o.date.day == t.day)
        .fold(0.0, (s, o) => s + o.totalAmount);
  }

  double get monthEarning {
    final t = DateTime.now();
    return orders.where((o) => o.status == 'delivered' &&
        o.date.year == t.year && o.date.month == t.month)
        .fold(0.0, (s, o) => s + o.totalAmount);
  }

  double get totalEarning =>
      orders.where((o) => o.status == 'delivered').fold(0.0, (s, o) => s + o.totalAmount);

  int get pendingCount   => orders.where((o) => o.status == 'pending').length;
  int get deliveredCount => orders.where((o) => o.status == 'delivered').length;
  int get totalStock     => products.fold(0, (s, p) => s + p.stock);

  List<ProductModel> get lowStock => products.where((p) => p.isLowStock).toList();
  List<OrderModel>   get recent   => orders.reversed.take(5).toList();

  List<double> get weeklyEarnings {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return orders.where((o) => o.status == 'delivered' &&
          o.date.year == day.year && o.date.month == day.month && o.date.day == day.day)
          .fold(0.0, (s, o) => s + o.totalAmount);
    });
  }

  List<int> get monthlyOrderCount {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final m = DateTime(now.year, now.month - (5 - i));
      return orders.where((o) => o.date.year == m.year && o.date.month == m.month).length;
    });
  }

  // ── Firestore Collection Refs ────────────────────────────────
  CollectionReference get _productsRef  => _db.collection('users').doc(uid).collection('products');
  CollectionReference get _ordersRef    => _db.collection('users').doc(uid).collection('orders');
  CollectionReference get _customersRef => _db.collection('users').doc(uid).collection('customers');
  CollectionReference get _brochureRef  => _db.collection('users').doc(uid).collection('brochure');

  @override
  void onInit() {
    super.onInit();
    _listenProducts();
    _listenOrders();
    _listenCustomers();
  }

  // ── Realtime Listeners ───────────────────────────────────────
  void _listenProducts() {
    _productsRef.snapshots().listen((snap) {
      products.assignAll(snap.docs.map((d) => ProductModel.fromDoc(d)));
      isLoadingProducts.value = false;
    }, onError: (_) => isLoadingProducts.value = false);
  }

  void _listenOrders() {
    _ordersRef.orderBy('date', descending: true).snapshots().listen((snap) {
      orders.assignAll(snap.docs.map((d) => OrderModel.fromDoc(d)));
      isLoadingOrders.value = false;
    }, onError: (_) => isLoadingOrders.value = false);
  }

  void _listenCustomers() {
    _customersRef.snapshots().listen((snap) {
      customers.assignAll(snap.docs.map((d) => CustomerModel.fromDoc(d)));
      isLoadingCustomers.value = false;
    }, onError: (_) => isLoadingCustomers.value = false);
  }

  // ── Products CRUD ────────────────────────────────────────────
  Future<void> addProduct(ProductModel p) async {
    try {
      await _productsRef.add(p.toMap());
      Get.back();
      _snack('Product Added', '${p.name} added successfully');
    } catch (e) { _err(e); }
  }

  Future<void> updateStock(String productId, int delta) async {
    try {
      await _productsRef.doc(productId).update({'stock': FieldValue.increment(delta)});
      _snack('Stock Updated', 'Stock updated successfully');
    } catch (e) { _err(e); }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productsRef.doc(productId).delete();
      _snack('Deleted', 'Product removed');
    } catch (e) { _err(e); }
  }

  // ── Orders CRUD ──────────────────────────────────────────────
  Future<void> addOrder(OrderModel o) async {
    final prod = products.firstWhereOrNull((p) => p.id == o.productId);
    if (prod != null && prod.stock < o.quantity) {
      Get.snackbar('Insufficient Stock', 'Available: ${prod.stock} pcs',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      final batch = _db.batch();
      // Add order
      final orderRef = _ordersRef.doc();
      batch.set(orderRef, {...o.toMap(), 'userId': uid});
      // Update stock
      if (prod != null) batch.update(_productsRef.doc(prod.id), {'stock': FieldValue.increment(-o.quantity)});
      // Update customer totals
      final cust = customers.firstWhereOrNull((c) => c.phone == o.customerPhone);
      if (cust != null) {
        batch.update(_customersRef.doc(cust.id), {
          'totalOrders': FieldValue.increment(1),
          'totalPurchase': FieldValue.increment(o.totalAmount),
        });
      }
      await batch.commit();
      Get.back();
      _snack('Order Added', '${o.customerName} — \u20B9${o.totalAmount.toInt()}');
    } catch (e) { _err(e); }
  }

  Future<void> markDelivered(String orderId) async {
    try {
      await _ordersRef.doc(orderId).update({'status': 'delivered'});
      _snack('Delivered!', 'Order marked as delivered');
    } catch (e) { _err(e); }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final order = orders.firstWhereOrNull((o) => o.id == orderId);
      if (order == null) return;
      final batch = _db.batch();
      batch.update(_ordersRef.doc(orderId), {'status': 'cancelled'});
      batch.update(_productsRef.doc(order.productId), {'stock': FieldValue.increment(order.quantity)});
      await batch.commit();
      _snack('Cancelled', 'Order cancelled and stock restored');
    } catch (e) { _err(e); }
  }

  // ── Customers CRUD ───────────────────────────────────────────
  Future<void> addCustomer(CustomerModel c) async {
    try {
      await _customersRef.add(c.toMap());
      Get.back();
      _snack('Customer Added', '${c.name} added successfully');
    } catch (e) { _err(e); }
  }

  // ── Brochure CRUD ────────────────────────────────────────────
  Stream<List<BrochureItem>> brochureStream() =>
      _brochureRef.snapshots().map((s) => s.docs.map((d) => BrochureItem.fromDoc(d)).toList());

  Future<void> addBrochureItem(BrochureItem item) async {
    try {
      await _brochureRef.add(item.toMap());
      Get.back();
      _snack('Added to Catalog', '${item.bucketName} added');
    } catch (e) { _err(e); }
  }

  Future<void> updateBrochureItem(String id, BrochureItem item) async {
    try {
      await _brochureRef.doc(id).update(item.toMap());
      Get.back();
      _snack('Updated', '${item.bucketName} updated');
    } catch (e) { _err(e); }
  }

  Future<void> deleteBrochureItem(String id) async {
    try {
      await _brochureRef.doc(id).delete();
      _snack('Deleted', 'Catalog item removed');
    } catch (e) { _err(e); }
  }

  void _snack(String t, String m) =>
      Get.snackbar(t, m, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
  void _err(dynamic e) =>
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
}
