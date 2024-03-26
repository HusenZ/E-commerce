import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/model/shop_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Shop>> getNearbyShops(double userLatitude, double userLongitude,
      {double radius = 10}) async {
    try {
      // Calculate latitude and longitude boundaries for the query
      double lowerLat = userLatitude -
          (radius /
              111.12); // 1 degree of latitude is approximately 111.12 kilometers
      double upperLat = userLatitude + (radius / 111.12);
      double lowerLon =
          userLongitude - (radius / (111.12 * cos(userLatitude * (pi / 180))));
      double upperLon =
          userLongitude + (radius / (111.12 * cos(userLatitude * (pi / 180))));

      // Query for shops within the latitude and longitude boundaries
      QuerySnapshot querySnapshot = await _firestore
          .collection('shops')
          .where('latitude', isGreaterThan: lowerLat)
          .where('latitude', isLessThan: upperLat)
          .where('longitude', isGreaterThan: lowerLon)
          .where('longitude', isLessThan: upperLon)
          .get();

      // Convert query snapshot to list of shops
      List<Shop> nearbyShops = querySnapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Shop(
            cid: data['cid'],
            openTime: data['openTime'],
            closeTime: data['closeTime'],
            deliveryAvailable: data['delivery'],
            location: data['location'],
            shopName: data['name'],
            ownerPhone: data['phNo'],
            shopLogoPath: data['shopLogo'],
            shopBannerPath: data['shopBanner'],
            latitude: data['latitude'],
            longitude: data['longitude']);
      }).toList();

      return nearbyShops;
    } catch (e) {
      // Handle errors here
      print("Error fetching nearby shops: $e");
      return [];
    }
  }

  Future<List<Product>> getProductsForShop(String shopId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Products')
          .where('shopId', isEqualTo: shopId)
          .get();

      // Convert query snapshot to list of products
      List<Product> products = querySnapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
            name: data['name'],
            price: data['price'],
            details: data['description'],
            imageUrl: data['selectedPhotos'],
            category: mapCategory[data['category']] ?? Category.men,
            shopId: data['shopId'],
            productId: data['productId']);
      }).toList();

      return products;
    } catch (e) {
      // Handle errors here
      print("Error fetching products for shop $shopId: $e");
      return [];
    }
  }
}
