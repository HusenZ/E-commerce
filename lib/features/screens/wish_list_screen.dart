import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/wish_list_repo.dart';
import 'package:daprot_v1/features/widgets/wish_list_widgets/wish_list_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: WishListRepo()
            .fetchWishlistedProducts(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No items in wishlist'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Product> wishlistProducts = [];
            List<String> productIds =
                List<String>.from(snapshot.data!.data()?['products'] ?? []);

            return ListView.builder(
              itemCount: productIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(productIds[index])
                      .get(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (!productSnapshot.hasData) {
                      return SizedBox(); // Placeholder or loading indicator
                    } else if (productSnapshot.hasError) {
                      return Text('Error: ${productSnapshot.error}');
                    } else {
                      Product product = Product(
                        name: productSnapshot.data!['name'],
                        price: productSnapshot.data!['price'],
                        details: productSnapshot.data!['details'],
                        imageUrl: productSnapshot.data!['imageUrl'],
                        category: Category
                            .men, // Assuming Category is a class or enum
                        shopId: productSnapshot.data!['shopId'],
                        productId: productIds[index],
                      );
                      wishlistProducts.add(product);
                      return WishlistItemCard(
                        product: product,
                        onRemoveFromWishlist: () {},
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
