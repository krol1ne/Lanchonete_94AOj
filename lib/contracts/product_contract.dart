abstract class ProductContract {
  final String imageUrl;
  final String name;
  final double price;
  final int id;

  ProductContract({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.id,
  });

  fromJson(Map<String, dynamic> json) {}
}
