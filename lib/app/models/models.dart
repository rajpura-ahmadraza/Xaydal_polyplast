import 'package:cloud_firestore/cloud_firestore.dart';

// ── Product Model ──────────────────────────────────────────────
class ProductModel {
  String id, name, size, color;
  double price;
  int stock, minStock;

  ProductModel({
    required this.id, required this.name, required this.price,
    required this.stock, required this.size,
    this.color = 'Silver', this.minStock = 20,
  });

  bool get isLowStock => stock <= minStock;

  Map<String, dynamic> toMap() => {
    'name': name, 'price': price, 'stock': stock,
    'minStock': minStock, 'size': size, 'color': color,
  };

  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id, name: d['name'] ?? '',
      price: (d['price'] as num).toDouble(),
      stock: d['stock'] ?? 0, size: d['size'] ?? '',
      color: d['color'] ?? 'Silver', minStock: d['minStock'] ?? 20,
    );
  }
}

// ── Order Model ────────────────────────────────────────────────
class OrderModel {
  String id, customerName, customerPhone, productId, productName, status, userId;
  int quantity;
  double pricePerUnit, totalAmount;
  DateTime date;
  String? notes;

  OrderModel({
    required this.id, required this.customerName, required this.customerPhone,
    required this.productId, required this.productName, required this.quantity,
    required this.pricePerUnit, required this.totalAmount,
    required this.status, required this.date,
    required this.userId, this.notes,
  });

  Map<String, dynamic> toMap() => {
    'customerName': customerName, 'customerPhone': customerPhone,
    'productId': productId, 'productName': productName,
    'quantity': quantity, 'pricePerUnit': pricePerUnit,
    'totalAmount': totalAmount, 'status': status,
    'date': Timestamp.fromDate(date), 'notes': notes, 'userId': userId,
  };

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id, customerName: d['customerName'] ?? '',
      customerPhone: d['customerPhone'] ?? '',
      productId: d['productId'] ?? '', productName: d['productName'] ?? '',
      quantity: d['quantity'] ?? 0,
      pricePerUnit: (d['pricePerUnit'] as num).toDouble(),
      totalAmount: (d['totalAmount'] as num).toDouble(),
      status: d['status'] ?? 'pending',
      date: (d['date'] as Timestamp).toDate(),
      userId: d['userId'] ?? '', notes: d['notes'],
    );
  }
}

// ── Customer Model ─────────────────────────────────────────────
class CustomerModel {
  String id, name, phone, userId;
  String? address;
  double totalPurchase;
  int totalOrders;
  DateTime createdAt;

  CustomerModel({
    required this.id, required this.name, required this.phone,
    required this.userId, this.address,
    this.totalPurchase = 0, this.totalOrders = 0,
    required this.createdAt,
  });

  bool get isVip => totalPurchase >= 10000;

  Map<String, dynamic> toMap() => {
    'name': name, 'phone': phone, 'address': address,
    'totalPurchase': totalPurchase, 'totalOrders': totalOrders,
    'createdAt': Timestamp.fromDate(createdAt), 'userId': userId,
  };

  factory CustomerModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CustomerModel(
      id: doc.id, name: d['name'] ?? '', phone: d['phone'] ?? '',
      address: d['address'], userId: d['userId'] ?? '',
      totalPurchase: (d['totalPurchase'] as num?)?.toDouble() ?? 0,
      totalOrders: d['totalOrders'] ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

// ── Brochure / Catalog Item ────────────────────────────────────
class BrochureItem {
  String id, userId;
  String bucketName, sizeInLiters, bodyWeight, lidWeight;
  double sellingPrice;
  String? imageUrl, description, material;

  BrochureItem({
    required this.id, required this.userId,
    required this.bucketName, required this.sizeInLiters,
    required this.bodyWeight, required this.lidWeight,
    required this.sellingPrice,
    this.imageUrl, this.description, this.material,
  });

  Map<String, dynamic> toMap() => {
    'bucketName': bucketName, 'sizeInLiters': sizeInLiters,
    'bodyWeight': bodyWeight, 'lidWeight': lidWeight,
    'sellingPrice': sellingPrice, 'imageUrl': imageUrl,
    'description': description, 'material': material ?? 'HDPE Plastic',
    'userId': userId,
  };

  factory BrochureItem.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return BrochureItem(
      id: doc.id, userId: d['userId'] ?? '',
      bucketName: d['bucketName'] ?? '', sizeInLiters: d['sizeInLiters'] ?? '',
      bodyWeight: d['bodyWeight'] ?? '', lidWeight: d['lidWeight'] ?? '',
      sellingPrice: (d['sellingPrice'] as num).toDouble(),
      imageUrl: d['imageUrl'], description: d['description'],
      material: d['material'] ?? 'HDPE Plastic',
    );
  }
}
