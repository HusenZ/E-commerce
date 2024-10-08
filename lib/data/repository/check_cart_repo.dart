import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckRepo {
  Stream<bool> checkCart(String productId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);
  }

  Stream<bool> checkOrderStatus(String productId) {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);
  }
}
