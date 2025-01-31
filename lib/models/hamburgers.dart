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
    final values = Values.fromJson(json['values']);
    return Hamburgers(
      images: _images,
      name: json['title'],
      description: json['description'],
      values: values,
      imageUrl: _images.isNotEmpty ? _images[0] : "",
      price: values.single, // Use single price as default
      id: json['id'],
    );
  }

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

  factory Values.fromJson(Map<String, dynamic> json) {
    return Values(
      single: (json['single'] as num).toDouble(),
      combo: (json['combo'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'single': single,
      'combo': combo,
    };
  }
}
