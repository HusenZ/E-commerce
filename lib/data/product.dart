enum Category { men, women, baby, cosmetic }

class Product {
  final String name;
  final String price;
  final String details;
  final String imageUrl;
  final Category category;
  final String shopId;

  Product({
    required this.name,
    required this.price,
    required this.details,
    required this.imageUrl,
    required this.category,
    required this.shopId,
  });
}

class CartProduct {
  final String name;
  final String price;
  final String details;
  final String imageUrl;
  final Category category;
  final String cpId;
  final String shopId;

  CartProduct({
    required this.name,
    required this.price,
    required this.details,
    required this.imageUrl,
    required this.category,
    required this.cpId,
    required this.shopId,
  });
}
