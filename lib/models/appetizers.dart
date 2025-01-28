class Appetizers {
  final int id;
  final String image;
  final String title;
  final String description;
  final ItemValues values;

  Appetizers({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.values,
  });

  // Factory constructor to create an Item from JSON
  factory Appetizers.fromJson(Map<String, dynamic> json) {
    return Appetizers(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      values: ItemValues.fromJson(json['values']),
    );
  }

  // Method to convert an Item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
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
