import 'package:cloud_firestore/cloud_firestore.dart';

enum Category {
  fashion,
  electronics,
  homeAndGarden,
  beautyAndHealth,
  sportsAndOutdoors,
  toysAndGames,
  babyAndKids,
  foodAndBeverages,
  automotive,
  pets,
  booksAndStationery,
  artsAndCrafts,
  officeSupplies,
  industrialAndScientific,
}

const mapCategory = {
  'fashion': Category.fashion,
  'electronics': Category.electronics,
  'homeAndGarden': Category.homeAndGarden,
  'beautyAndHealth': Category.beautyAndHealth,
  "sportsAndOutdoors": Category.sportsAndOutdoors,
  "toysAndGames": Category.toysAndGames,
  "babyAndKids": Category.babyAndKids,
  "foodAndBeverages": Category.foodAndBeverages,
  "automotive": Category.automotive,
  "pets": Category.pets,
  "booksAndStationery": Category.booksAndStationery,
  "artsAndCrafts": Category.artsAndCrafts,
  "officeSupplies": Category.officeSupplies,
  "industrialAndScientific": Category.industrialAndScientific,
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
