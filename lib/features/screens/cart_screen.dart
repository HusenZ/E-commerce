import 'package:daprot_v1/bloc/cart_bloc/cart_bloc.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/model/order_models.dart';
import 'package:daprot_v1/domain/order_repo.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/widgets/common_widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: ProductStream().getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("no data availabel"),
              );
            }
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  backgroundColor: ColorsManager.primaryColor,
                  title: Text("My Cart"),
                ),
                SliverList.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        BlocProvider.of<CartBloc>(context).add(RemoveFromCart(
                            snapshot.data!.docs[index]['cartItemId']));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('dismissed'),
                          ),
                        );
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              height: 15.h,
                              width: 35.w,
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Image.network(
                                snapshot.data!.docs[index]['image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]['name'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  snapshot.data!.docs[index]['price'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  try {
                                    UserOrderRepository().placeOrder(OrderModel(
                                      shopId: snapshot.data!.docs[index]
                                          ['shopId'],
                                      orderId: const Uuid().v4(),
                                      orderItems: [
                                        OrderItem(
                                          shopId: snapshot.data!.docs[index]
                                              ['shopId'],
                                          cpId: const Uuid().v4(),
                                          imageUrl: snapshot.data!.docs[index]
                                              ['image'],
                                          name: snapshot.data!.docs[index]
                                              ['name'],
                                          details: snapshot.data!.docs[index]
                                              ['description'],
                                          price: snapshot.data!.docs[index]
                                              ['price'],
                                          category: Category.men,
                                        ),
                                      ],
                                      totalPrice: snapshot.data!.docs[index]
                                          ['price'],
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      orderStatus: OrderStatus.pending.name,
                                      orderDate: DateTime.now(),
                                    ));
                                    customSnackBar(context, 'Success', true);
                                  } catch (e) {
                                    print(e);
                                    customSnackBar(context, 'Failed', false);
                                  }
                                },
                                child: const Text("Buy")),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
