class Categories {
  final String id;
  final String text;
  final String link;
  final int number;

  Categories({
    required this.id,
    required this.text,
    required this.link,
    required this.number,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      number: json['number'] is int ? json['number'] : int.tryParse(json['number']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'link': link,
      'number': number,
    };
  }
}
