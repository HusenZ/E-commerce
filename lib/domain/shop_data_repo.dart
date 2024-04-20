import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/domain/model/shop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> fetchShopName(String shopId) async {
    try {
      // Reference to the shop document
      final shopSnapshot = await FirebaseFirestore.instance
          .collection('Shops')
          .doc(shopId)
          .get();

      // Extract and return the shop name
      return shopSnapshot['name'];
    } catch (e) {
      // Error occurred while fetching shop name
      print('Error fetching shop name: $e');
      return '';
    }
  }

  Stream<QuerySnapshot> getProductStream() {
    return _firestore
        .collection('Products')
        .where('location', isEqualTo: 'Bagalkot')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsForShopsStream(
      String locality) {
    print("The locality on the stream ---> $locality");
    return _firestore
        .collection('Products')
        .where('location', isEqualTo: locality)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getShopProductStream(
      String shopId) {
    return _firestore
        .collection('Products')
        .where('shopId', isEqualTo: shopId)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getShopStream(String uid) {
    return _firestore.collection('Shops').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getCartItems() {
    return _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderItems() {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Stream<List<Shop>> getShopsStream() {
    // Replace 'shops' with your actual collection name in Firestore
    return FirebaseFirestore.instance.collection('Shops').snapshots().map(
      (querySnapshot) {
        final shops =
            querySnapshot.docs.map((doc) => Shop.fromFirestore(doc)).toList();
        return shops;
      },
    );
  }

  Stream<List<Shop>> getNearbyShops(String? userLocality) {
    print("Enterd the stream--- $userLocality");
    return FirebaseFirestore.instance.collection('Shops').snapshots().map(
      (querySnapshot) {
        print(querySnapshot.docs.length);
        final shops = querySnapshot.docs
            .map((doc) => Shop.fromFirestore(doc))
            .where((shop) => shop.location.contains(userLocality!))
            .toList();
        print(shops.first.shopName);
        return shops;
      },
    );
  }
}
