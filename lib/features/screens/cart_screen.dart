import 'package:daprot_v1/bloc/cart_bloc/cart_bloc.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/model/order_models.dart';
import 'package:daprot_v1/domain/order_repo.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/widgets/cart_screen_widget/cart_card.dart';
import 'package:daprot_v1/features/widgets/common_widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    int itemQuantity = 1;

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
                      confirmDismiss: (DismissDirection direction) async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to remove this item?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Dismiss the dialog and return false to cancel the dismissal
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                        return result ?? false;
                      },
                      background: Container(
                        color: const Color.fromARGB(175, 244, 67, 54),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(
                            right: 20.h), // Background color when swiping
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      onDismissed: (direction) {
                        BlocProvider.of<CartBloc>(context).add(RemoveFromCart(
                            snapshot.data!.docs[index]['cartItemId']));
                        customSnackBar(context, 'Removed From the cart', true);
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: Product(
                                  name: snapshot.data!.docs[index]['name'],
                                  price: snapshot.data!.docs[index]['price'],
                                  details: snapshot.data!.docs[index]
                                      ['description'],
                                  imageUrl: snapshot.data!.docs[index]['image'],
                                  category: Category.men,
                                  shopId: snapshot.data!.docs[index]['shopId'],
                                  productId: snapshot.data!.docs[index]
                                      ['productId'],
                                ),
                              ),
                            ),
                          );
                        },
                        child: CartItemCard(
                          productId: snapshot.data!.docs[index]['productId'],
                          imageUrl: snapshot.data!.docs[index]['image'],
                          title: snapshot.data!.docs[index]['name'],
                          price: snapshot.data!.docs[index]['price'],
                          quantity: itemQuantity,
                          onBuyPressed: (price, quantity) {
                            try {
                              UserOrderRepository().placeOrder(OrderModel(
                                shopId: snapshot.data!.docs[index]['shopId'],
                                orderId: const Uuid().v4(),
                                productId: snapshot.data!.docs[index]
                                    ['productId'],
                                orderItems: [
                                  OrderItem(
                                    shopId: snapshot.data!.docs[index]
                                        ['shopId'],
                                    cpId: const Uuid().v4(),
                                    imageUrl: snapshot.data!.docs[index]
                                        ['image'],
                                    name: snapshot.data!.docs[index]['name'],
                                    details: snapshot.data!.docs[index]
                                        ['description'],
                                    price: snapshot.data!.docs[index]['price'],
                                    category: Category.men,
                                  ),
                                ],
                                totalPrice: price,
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                orderStatus: OrderStatus.pending.name,
                                quantity: quantity.toString(),
                                orderDate: DateTime.now(),
                              ));
                              customSnackBar(context, 'Success', true);
                            } catch (e) {
                              print(e);
                              customSnackBar(context, 'Failed', false);
                            }
                          },
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
