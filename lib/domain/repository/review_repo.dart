// ignore_for_file: null_argument_to_non_null_type

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewsRepo {
  static Future<DocumentSnapshot<Object?>> getReviews(String productId) async {
    QuerySnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    String productIdDocId = productSnapshot.docs.first.id;
    if (productSnapshot.docs.isNotEmpty) {
      CollectionReference reviewsRef = FirebaseFirestore.instance
          .collection('Products')
          .doc(productIdDocId)
          .collection('Reviews');
      return reviewsRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    } else {
      return Future.value(null);
    }
  }
}
