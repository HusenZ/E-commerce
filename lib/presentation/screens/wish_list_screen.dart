import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/core/constants/lottie_img.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/domain/repository/wish_list_repo.dart';
import 'package:gozip/presentation/screens/index.dart';
import 'package:gozip/presentation/widgets/wish_list_widgets/wish_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WishList'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: WishListRepo().getWishListProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No items in wishlist'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Product>? wishlistProducts;
            List<String> productIds =
                snapshot.data!.docs.map((doc) => doc.id).toList();
            print("------------->${productIds.length}");

            // Fetch all product details in parallel

            Future<List<Product>> _fetchProducts(
                List<String> productIds) async {
              List<Product> allProducts = [];
              for (var productId in productIds) {
                final productSnapshot = await FirebaseFirestore.instance
                    .collection('Products')
                    .where('productId', isEqualTo: productId)
                    .get();

                for (var doc in productSnapshot.docs) {
                  final productData = doc.data();
                  allProducts.add(Product(
                    name: productData['name'],
                    price: productData['price'],
                    details: productData['description'],
                    imageUrl: productData['selectedPhotos'],
                    category: mapCategory[productData['category']]!,
                    shopId: productData['shopId'],
                    productId: productId,
                    discountedPrice: productData['discountedPrice'],
                  ));
                }
              }
              return allProducts;
            }

            final Future<List<Product>> futureProducts =
                _fetchProducts(productIds);

            return FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  wishlistProducts = productSnapshot.data!;
                  if (productIds.isEmpty) {
                    return Column(
                      children: [
                        Lottie.asset(AppLottie.empty),
                        Text(
                          "Add Products To the wish list",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: ColorsManager.primaryColor,
                                  ),
                        )
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: wishlistProducts!.length,
                      itemBuilder: (context, index) {
                        final product = wishlistProducts![index];
                        return InkWell(
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductScreen(product: product),
                            ),
                          ),
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: ScaleAnimation(
                              child: WishlistItemCard(
                                product: product,
                                onRemoveFromWishlist: () {
                                  WishListRepo()
                                      .removeFromWishList(product.productId);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
