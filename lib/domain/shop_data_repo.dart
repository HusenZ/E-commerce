import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getProductStream() {
    return _firestore.collection('Products').snapshots();
  }

  Stream<QuerySnapshot> getShopStream(String uid) {
    return _firestore
        .collection('Sellers')
        .doc(uid)
        .collection('Applications')
        .snapshots();
  }

  Stream<QuerySnapshot> getCartItems() {
    return _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .snapshots();
  }
}
