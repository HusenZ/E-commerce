import 'package:gozip/bloc/cart_bloc/cart_bloc.dart';
import 'package:gozip/core/constants/lottie_img.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/domain/repository/connectivity_helper.dart';
import 'package:gozip/domain/entities/order_models.dart';
import 'package:gozip/domain/repository/order_repo.dart';
import 'package:gozip/domain/repository/shop_data_repo.dart';
import 'package:gozip/presentation/screens/product_details_screen.dart';
import 'package:gozip/presentation/widgets/cart_screen_widget/cart_card.dart';
import 'package:gozip/presentation/widgets/common_widgets/delevated_button.dart';
import 'package:gozip/presentation/widgets/common_widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String orderId = const Uuid().v1();
  ProductStream stream = ProductStream();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 218, 40, 40),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int itemQuantity = 1;
    OrderModel? orderModel;

    return Scaffold(
      body: StreamBuilder(
          stream: stream.getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LottieBuilder.asset(AppLottie.cartEmpty),
                  Center(
                    child: Text(
                      "Cart Is Empty, Add Proucts To Your Cart",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12.sp, color: ColorsManager.primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  DelevatedButton(
                      text: "Explore Proucts",
                      onTap: () {
                        ConnectivityHelper.naviagte(context, Routes.homeRoute);
                      })
                ],
              );
            }
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: ColorsManager.primaryColor,
                  title: Text("My Cart"),
                ),
                SliverList.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: FlipAnimation(
                        child: Dismissible(
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
                            BlocProvider.of<CartBloc>(context).add(
                              RemoveFromCart(
                                  snapshot.data!.docs[index]['cartItemId']),
                            );
                            customSnackBar(
                                context, 'Removed From the cart', true);
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    product: Product(
                                      name: snapshot.data!.docs[index]['name'],
                                      price: snapshot.data!.docs[index]
                                          ['price'],
                                      details: snapshot.data!.docs[index]
                                          ['description'],
                                      imageUrl: snapshot.data!.docs[index]
                                          ['image'],
                                      category: mapCategory[snapshot
                                          .data!.docs[index]['category']]!,
                                      shopId: snapshot.data!.docs[index]
                                          ['shopId'],
                                      productId: snapshot.data!.docs[index]
                                          ['productId'],
                                      discountedPrice: snapshot
                                          .data!.docs[index]['discountedPrice'],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: CartItemCard(
                              productId: snapshot.data!.docs[index]
                                  ['productId'],
                              imageUrl:
                                  snapshot.data!.docs[index]['image'].first,
                              title: snapshot.data!.docs[index]['name'],
                              price: snapshot.data!.docs[index]
                                  ['discountedPrice'],
                              quantity: itemQuantity,
                              orderModel: OrderModel(
                                shopId: snapshot.data!.docs[index]['shopId'],
                                orderId: orderId,
                                productId: snapshot.data!.docs[index]
                                    ['productId'],
                                orderItems: [
                                  OrderItem(
                                    shopId: snapshot.data!.docs[index]
                                        ['shopId'],
                                    productId: const Uuid().v4(),
                                    imageUrl: snapshot.data!.docs[index]
                                        ['image'],
                                    name: snapshot.data!.docs[index]['name'],
                                    details: snapshot.data!.docs[index]
                                        ['description'],
                                    price: snapshot.data!.docs[index]['price'],
                                    discountedPrice: snapshot.data!.docs[index]
                                        ['discountedPrice'],
                                    category: mapCategory[snapshot
                                        .data!.docs[index]['category']]!,
                                  ),
                                ],
                                totalPrice: 'price',
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                orderStatus: OrderStatus.pending.name,
                                quantity: '1',
                                orderDate: DateTime.now().toString(),
                              ),
                              onBuyPressed: (price, quantity) {
                                OrderModel(
                                  shopId: snapshot.data!.docs[index]['shopId'],
                                  orderId: orderId,
                                  productId: snapshot.data!.docs[index]
                                      ['productId'],
                                  orderItems: [
                                    OrderItem(
                                      shopId: snapshot.data!.docs[index]
                                          ['shopId'],
                                      productId: const Uuid().v4(),
                                      imageUrl: snapshot.data!.docs[index]
                                          ['image'],
                                      name: snapshot.data!.docs[index]['name'],
                                      details: snapshot.data!.docs[index]
                                          ['description'],
                                      price: snapshot.data!.docs[index]
                                          ['price'],
                                      discountedPrice: snapshot
                                          .data!.docs[index]['discountedPrice'],
                                      category: mapCategory[snapshot
                                          .data!.docs[index]['category']]!,
                                    ),
                                  ],
                                  totalPrice: price,
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  orderStatus: OrderStatus.pending.name,
                                  quantity: quantity.toString(),
                                  orderDate: DateTime.now().toString(),
                                );
                                try {
                                  UserOrderRepository().placeOrder(
                                    orderModel!,
                                  );
                                  customSnackBar(context, 'Success', true);
                                } catch (e) {
                                  customSnackBar(context, 'Failed', false);
                                }
                              },
                            ),
                          ),
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
