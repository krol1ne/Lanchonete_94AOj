import 'package:lanchonete/contracts/product_contract.dart';

class Hamburgers extends ProductContract {
  final List<String> images;
  final String description;
  final Values values;

  Hamburgers({
    required this.images,
    required this.description,
    required this.values,
    required super.imageUrl,
    required super.name,
    required super.price,
    required super.id,
  });

  @override
  factory Hamburgers.fromJson(Map<String, dynamic> json) {
    final _images = List<String>.from(json['image']);
    return Hamburgers(
      images: List<String>.from(json['image']),
      name: json['title'],
      description: json['description'],
      values: Values.fromJson(json['values']),
      imageUrl: _images[0] ?? "",
      price: 0,
      id: json['id'],
    );
  }

  // Method to convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': images,
      'title': name,
      'description': description,
      'values': values.toJson(),
    };
  }
}

class Values {
  final double single;
  final double combo;

  Values({
    required this.single,
    required this.combo,
  });

  // Factory constructor to create Values from JSON
  factory Values.fromJson(Map<String, dynamic> json) {
    return Values(
      single: json['single'].toDouble(),
      combo: json['combo'].toDouble(),
    );
  }

  // Method to convert Values to JSON
  Map<String, dynamic> toJson() {
    return {
      'single': single,
      'combo': combo,
    };
  }
}
