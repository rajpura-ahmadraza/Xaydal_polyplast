class CustomerModel {
  String id;
  String name;
  String phone;
  String? address;
  double totalPurchase;
  int totalOrders;
  DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.address,
    this.totalPurchase = 0,
    this.totalOrders = 0,
    required this.createdAt,
  });

  bool get isVip => totalPurchase >= 10000;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'address': address,
        'totalPurchase': totalPurchase,
        'totalOrders': totalOrders,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        address: json['address'],
        totalPurchase: json['totalPurchase']?.toDouble() ?? 0,
        totalOrders: json['totalOrders'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
      );
}
