class PaymentOptions {
  final String id;
  final int number;
  final String text;

  PaymentOptions({
    required this.id,
    required this.number,
    required this.text,
  });

  factory PaymentOptions.fromJson(Map<String, dynamic> json) {
    return PaymentOptions(
      id: json['id'],
      number: json['number'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'text': text,
    };
  }
}
