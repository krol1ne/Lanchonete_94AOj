class Beverages {
  final int id;
  final String image;
  final String title;
  final String description;
  final int value;

  Beverages({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.value,
  });

  factory Beverages.fromJson(Map<String, dynamic> json) {
    return Beverages(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'value': value,
    };
  }
}
