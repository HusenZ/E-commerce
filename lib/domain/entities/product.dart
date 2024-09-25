import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/domain/entities/category.dart';

const mapCategory = {
  'men': Category.men,
  'women': Category.women,
  'electronicsAndGadgets': Category.electronicsAndGadgets,
  'accessories': Category.accessories,
};

class Product {
  final String name;
  final String price;
  final String details;
  final List<dynamic> imageUrl;
  final Category? category;
  final String shopId;
  final String productId;
  final String discountedPrice;

  Product({
    required this.name,
    required this.discountedPrice,
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
        discountedPrice: snapshot.get('discountedPrice'),
        productId: snapshot.get('productId'));
  }
}

class CartProduct {
  final String name;
  final String price;
  final String details;
  final List<String> imageUrl;
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
