import 'package:cloud_firestore/cloud_firestore.dart';

class WishListRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchWishlistedProducts(
    String userId,
  ) {
    return _firestore.collection('wishlists').doc(userId).snapshots();
  }
}
