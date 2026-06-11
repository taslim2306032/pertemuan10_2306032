import 'dart:convert';

class ProductModel {
  final String name;
  final String description;
  final int price;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
  });

  // OBJECT -> MAP
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  // MAP -> OBJECT
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  // OBJECT -> JSON STRING
  String toJson() => jsonEncode(toMap());

  // JSON STRING -> OBJECT
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(jsonDecode(source));
  }
}
