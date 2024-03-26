import 'package:cloud_firestore/cloud_firestore.dart';

enum Category { men, women, baby, cosmetic }

const mapCategory = {
  'men': Category.men,
  'women': Category.women,
  'baby': Category.baby,
  'cosmetic': Category.cosmetic,
};

class Product {
  final String name;
  final String price;
  final String details;
  final String imageUrl;
  final Category category;
  final String shopId;
  final String productId;

  Product({
    required this.name,
    required this.price,
    required this.details,
    required this.imageUrl,
    required this.category,
    required this.shopId,
    required this.productId,
  });
  factory Product.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Product(
        name: snapshot.get('name'),
        price: snapshot.get('price'),
        details: snapshot.get('description'),
        imageUrl: snapshot.get('imageUrl'),
        category: snapshot.get('category'),
        shopId: snapshot.get('shopId'),
        productId: snapshot.get('productId'));
  }
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
