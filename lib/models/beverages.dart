import 'package:lanchonete/contracts/product_contract.dart';

class Beverages extends ProductContract {
  final String description;

  Beverages({
    required this.description,
    required super.imageUrl,
    required super.name,
    required super.price,
    required super.id,
  });

  @override
  factory Beverages.fromJson(Map<String, dynamic> json) {
    return Beverages(
      id: json['id'],
      imageUrl: json['image'],
      name: json['title'],
      price: json['value'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'title': name,
      'description': description,
      'value': price,
    };
  }
}
