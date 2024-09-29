import 'package:gozip/domain/entities/user_model.dart';
import 'package:gozip/domain/repository/user_data_repo.dart';
import 'package:gozip/presentation/widgets/product_s_widget/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class ReviewWidget extends StatelessWidget {
  final String productId;

  const ReviewWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    UserDataManager repo = UserDataManager();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .where('productId', isEqualTo: productId)
          .limit(1)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Text('No reviews yet');
        }

        // Get the document ID of the product
        String productIdDocId = snapshot.data!.docs.first.id;

        // Reference to the Reviews subcollection of the product
        CollectionReference reviewsRef = FirebaseFirestore.instance
            .collection('Products')
            .doc(productIdDocId)
            .collection('Reviews');

        return StreamBuilder<QuerySnapshot>(
          stream: reviewsRef.snapshots(),
          builder: (context, reviewSnapshot) {
            if (reviewSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (reviewSnapshot.hasError) {
              return Text('Error: ${reviewSnapshot.error}');
            }

            final List<QueryDocumentSnapshot> reviews =
                reviewSnapshot.data!.docs;

            if (reviews.isEmpty) {
              return const Text('No reviews yet');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var review in reviews)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              StreamBuilder<UserModel>(
                                  stream: repo.streamUserUid(review['userID']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }
                                    if (snapshot.data == null ||
                                        !snapshot.hasData) {
                                      return const Text('User');
                                    }
                                    return Text(
                                      snapshot.data!.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  }),
                              RatingBarIndicator(
                                rating:
                                    double.parse(review['rating'].toString()),
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 24,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          ExpandableText(review['review']),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
