class Hamburgers {
  final int id;
  final List<String> images;
  final String title;
  final String description;
  final Values values;

  Hamburgers({
    required this.id,
    required this.images,
    required this.title,
    required this.description,
    required this.values,
  });

  factory Hamburgers.fromJson(Map<String, dynamic> json) {
    return Hamburgers(
      id: json['id'],
      images: List<String>.from(json['image']),
      title: json['title'],
      description: json['description'],
      values: Values.fromJson(json['values']),
    );
  }

  // Method to convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': images,
      'title': title,
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
