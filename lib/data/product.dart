enum Category { men, women, child, cosmetic }

class Product {
  final String name;
  final double price;
  final String details;
  final String imageUrl;
  final Category category;

  Product({
    required this.name,
    required this.price,
    required this.details,
    required this.imageUrl,
    required this.category,
  });
}
