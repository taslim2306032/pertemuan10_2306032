import 'dart:convert';

class ProductModel {

  //instalasi ariasble data product
  final String name;
  final String description;
  final int price;
  final String image;
//construktor
  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // OBJECT -> MAP
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  // MAP -> OBJECT
  factory ProductModel.fromMap(
    Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      image: map['image'] ?? '',
    );
  }

  // OBJECT -> JSON STRING
  String toJson() => jsonEncode(toMap());

  // JSON STRING -> OBJECT
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(jsonDecode(source));
  }
}
