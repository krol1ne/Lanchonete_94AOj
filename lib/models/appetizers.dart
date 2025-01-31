import 'package:lanchonete/contracts/product_contract.dart';

class Appetizers extends ProductContract {
  final String description;
  final ItemValues values;

  Appetizers({
    required this.description,
    required this.values,
    required super.imageUrl,
    required super.name,
    required super.price,
    required super.id,
  });

  @override
  factory Appetizers.fromJson(Map<String, dynamic> json) {
    final values = ItemValues.fromJson(json['values']);
    return Appetizers(
      id: json['id'],
      imageUrl: json['image'],
      name: json['title'],
      description: json['description'],
      values: values,
      price: values.small ?? values.large ?? 0.0, // Use small price as default, fallback to large if small is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'title': name,
      'description': description,
      'values': values.toJson(),
    };
  }
}

class ItemValues {
  final double? small;
  final double? large;

  ItemValues({
    this.small,
    this.large,
  });

  factory ItemValues.fromJson(Map<String, dynamic> json) {
    return ItemValues(
      small: json['small'] != null ? (json['small'] as num).toDouble() : null,
      large: json['large'] != null ? (json['large'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'large': large,
    };
  }
}
