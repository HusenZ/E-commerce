import 'package:gozip/bloc/review_bloc/add_review_events.dart';
import 'package:gozip/bloc/review_bloc/add_review_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  ProductReviewBloc() : super(ProductReviewInitial()) {
    on<AddReviewEvent>((event, emit) async {
      emit(ProductReviewLoading());
      try {
        QuerySnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('Products')
            .where('productId', isEqualTo: event.productId)
            .limit(1)
            .get();

        if (productSnapshot.docs.isNotEmpty) {
          String productIdDocId = productSnapshot.docs.first.id;

          CollectionReference reviewsRef = FirebaseFirestore.instance
              .collection('Products')
              .doc(productIdDocId)
              .collection('Reviews');

          await reviewsRef.doc(userId).set({
            'rating': event.rating,
            'review': event.review,
            'userID': userId,
            'timestamp': DateTime.now().toString(),
          });
        } else {
          print(
              '---------> Product with productId ${event.productId} not found.');
          emit(ProductReviewFailure(
              '---------> Product with productId ${event.productId} not found.'));
        }
        emit(ProductReviewSuccess());
      } catch (e) {
        emit(ProductReviewFailure(e.toString()));
      }
    });
  }
}
