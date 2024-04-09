import 'package:daprot_v1/config/constants/lottie_img.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/screens/shops_screen.dart';
import 'package:daprot_v1/features/widgets/cart_screen_widget/cart_card.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ProductStream repo = ProductStream();
  @override
  Widget build(BuildContext context) {
    int itemQuantity = 1;

    return Scaffold(
      body: StreamBuilder(
          stream: repo.orderItems(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorsManager.primaryColor,
                  title: const Text("My Orders"),
                ),
                body: Column(
                  children: [
                    Center(
                      child: Lottie.asset(AppLottie.splashScreenBottom),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ShopsScreen()));
                        },
                        child: const Text("Explore Shops"))
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("My Orders"),
                ),
                body: Lottie.asset(AppLottie.splashScreenBottom),
              );
            } else {
              return CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    backgroundColor: ColorsManager.primaryColor,
                    title: Text("My Orders"),
                  ),
                  SliverList.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: Product(
                                    name: snapshot
                                        .data!
                                        .docs[index]['orderItems']
                                        .first['name'],
                                    price: snapshot
                                        .data!
                                        .docs[index]['orderItems']
                                        .first['price'],
                                    details: snapshot
                                        .data!
                                        .docs[index]['orderItems']
                                        .first['details'],
                                    imageUrl: snapshot
                                        .data!
                                        .docs[index]['orderItems']
                                        .first['imageUrl'],
                                    category: mapCategory[snapshot
                                        .data!.docs[index]['category']]!,
                                    shopId: snapshot.data!.docs[index]
                                        ['shopId'],
                                    productId: snapshot.data!.docs[index]
                                        ['productId'],
                                    discountedPrice: snapshot.data!.docs[index]
                                        ['discountedPrice']),
                              ),
                            ),
                          );
                        },
                        child: OrderItemCard(
                          productId: snapshot.data!.docs[index]['productId'],
                          imageUrl: snapshot.data!.docs[index]['orderItems']
                              .first['imageUrl'],
                          title: snapshot
                              .data!.docs[index]['orderItems'].first['name'],
                          price: snapshot.data!.docs[index]['totalPrice'],
                          quantity: itemQuantity,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          }),
    );
  }
}
