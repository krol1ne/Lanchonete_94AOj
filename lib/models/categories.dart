class Categories {
  final int id;
  final String text;
  final String link;

  Categories({
    required this.id,
    required this.text,
    required this.link,
  });

  @override
  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      text: json['text'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'link': link,
    };
  }
}
