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

  // Factory constructor to create an Item from JSON
  @override
  factory Appetizers.fromJson(Map<String, dynamic> json) {
    return Appetizers(
      id: json['id'],
      imageUrl: json['image'],
      name: json['title'],
      description: json['description'],
      price: 0,
      values: ItemValues.fromJson(json['values']),
    );
  }

  // Method to convert an Item to JSON
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

  // Factory constructor to create ItemValues from JSON
  factory ItemValues.fromJson(Map<String, dynamic> json) {
    return ItemValues(
      small: json['small'] != null ? json['small'].toDouble() : null,
      large: json['large'] != null ? json['large'].toDouble() : null,
    );
  }

  // Method to convert ItemValues to JSON
  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'large': large,
    };
  }
}
