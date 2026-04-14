// Product Model
class ProductModel {
  String id;
  String name;
  double price;
  int stock;
  int minStock;
  String size; // '5L', '10L', '20L', etc.
  String color;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.size,
    this.color = 'Blue',
    this.minStock = 20,
  });

  bool get isLowStock => stock <= minStock;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'stock': stock,
        'minStock': minStock,
        'size': size,
        'color': color,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        stock: json['stock'],
        size: json['size'],
        color: json['color'] ?? 'Blue',
        minStock: json['minStock'] ?? 20,
      );
}
