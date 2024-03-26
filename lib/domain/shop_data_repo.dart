import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/domain/model/shop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getProductStream() {
    return _firestore.collection('Products').snapshots();
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
}
