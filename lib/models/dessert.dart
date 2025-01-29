import 'package:lanchonete/contracts/product_contract.dart';

class Dessert extends ProductContract {
  final String description;

  Dessert({
    required super.id,
    required this.description,
    required super.imageUrl,
    required super.name,
    required super.price,
  });

  @override
  factory Dessert.fromJson(Map<String, dynamic> json) {
    return Dessert(
      id: json['id'],
      imageUrl: json['image'],
      name: json['title'],
      description: json['description'],
      price: json['value'].toDouble(),
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
