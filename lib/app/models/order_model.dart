class OrderModel {
  String id;
  String customerName;
  String customerPhone;
  String productId;
  String productName;
  int quantity;
  double pricePerUnit;
  double totalAmount;
  String status; // 'pending' | 'delivered' | 'cancelled'
  DateTime date;
  String? notes;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.status,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'pricePerUnit': pricePerUnit,
        'totalAmount': totalAmount,
        'status': status,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        productId: json['productId'],
        productName: json['productName'],
        quantity: json['quantity'],
        pricePerUnit: json['pricePerUnit'].toDouble(),
        totalAmount: json['totalAmount'].toDouble(),
        status: json['status'],
        date: DateTime.parse(json['date']),
        notes: json['notes'],
      );
}
