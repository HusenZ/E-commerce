import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/data/product.dart';
import 'package:gozip/views/screens/product_details_screen.dart';
import 'package:gozip/views/widgets/home_widgets/home_product_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryProducts extends StatelessWidget {
  const CategoryProducts(
      {super.key, required this.subCategory, required this.trimmedLocality});
  final String subCategory;
  final String trimmedLocality;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .where('location', isEqualTo: trimmedLocality)
              .where('subCategory', isEqualTo: subCategory)
              .orderBy('clicks', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.data == null) {
              return const Scaffold(
                  body: Center(child: Text("no prodcuts available")));
            }
            return CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of grid columns
                    crossAxisSpacing: 10, // Spacing between grid items
                    mainAxisSpacing: 10, // Spacing between grid rows
                    childAspectRatio:
                        0.7, // Aspect ratio of grid items (width / height)
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return HomeProductCard(
                        product: Product(
                          name: snapshot.data!.docs[index]['name'],
                          price: snapshot.data!.docs[index]['price'],
                          details: snapshot.data!.docs[index]['description'],
                          imageUrl: snapshot.data!.docs[index]
                              ['selectedPhotos'],
                          shopId: snapshot.data!.docs[index]['shopId'],
                          category: mapCategory[snapshot.data!.docs[index]
                              ['category']],
                          productId: snapshot.data!.docs[index]['productId'],
                          discountedPrice: snapshot.data!.docs[index]
                              ['discountedPrice'],
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: Product(
                                  name: snapshot.data!.docs[index]['name'],
                                  price: snapshot.data!.docs[index]['price'],
                                  details: snapshot.data!.docs[index]
                                      ['description'],
                                  imageUrl: snapshot.data!.docs[index]
                                      ['selectedPhotos'],
                                  shopId: snapshot.data!.docs[index]['shopId'],
                                  category: mapCategory[
                                      snapshot.data!.docs[index]['category']],
                                  productId: snapshot.data!.docs[index]
                                      ['productId'],
                                  discountedPrice: snapshot.data!.docs[index]
                                      ['discountedPrice'],
                                ),
                              ),
                            ),
                          );
                          await snapshot.data!.docs[index].reference.update({
                            'clicks': FieldValue.increment(1),
                          });
                        },
                        height: 30.h,
                        width: 2.h,
                      );
                    },
                    childCount: snapshot.data!.docs.length,
                  ),
                )
              ],
            );
          }),
    );
  }
}
