import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/domain/helper/connectivity_helper.dart';
import 'package:gozip/domain/entities/order_models.dart';
import 'package:gozip/data/repository/shop_data_repo.dart';
import 'package:gozip/presentation/screens/order_details_screen.dart';
import 'package:gozip/presentation/screens/product_details_screen.dart';
import 'package:gozip/presentation/widgets/cart_screen_widget/cart_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sizer/sizer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProductStream repo = ProductStream();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        ConnectivityHelper.clareStackPush(context, Routes.homeRoute);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primaryColor,
          title: const Text("My Orders"),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            unselectedLabelColor: ColorsManager.whiteColor,
            labelColor: ColorsManager.accentColor,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 12.sp),
            controller: _tabController,
            tabs: const [
              Tab(text: 'Orders'),
              Tab(text: 'Delivered'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOrdersTab(),
            _buildDeliveredTab(),
            _buildCancelledTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    return StreamBuilder(
      stream: repo.orderItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty ||
            snapshot.data!.docs.where((item) {
              return item['orderStatus'] == OrderStatus.pending.name;
            }).isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No Pending Orders.."),
                ElevatedButton(
                  onPressed: () {
                    ConnectivityHelper.replaceIfConnected(
                        context, Routes.shopsRoute);
                  },
                  child: const Text("Explore Shops"),
                ),
              ],
            ),
          );
        } else {
          return _buildOrderList(snapshot, OrderStatus.pending);
        }
      },
    );
  }

  Widget _buildDeliveredTab() {
    return StreamBuilder(
      stream: repo.orderItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty ||
            snapshot.data!.docs.where((item) {
              return item['orderStatus'] == OrderStatus.delivered.name;
            }).isEmpty) {
          return const Center(child: Text("No delivered orders found."));
        } else {
          return _buildOrderList(snapshot, OrderStatus.delivered);
        }
      },
    );
  }

  Widget _buildCancelledTab() {
    return StreamBuilder(
      stream: repo.orderItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No cancelled orders found."));
        } else {
          return _buildOrderList(snapshot, OrderStatus.cancelled);
        }
      },
    );
  }

  Widget _buildOrderList(AsyncSnapshot snapshot, OrderStatus status) {
    List<DocumentSnapshot> orderedItems = snapshot.data!.docs.where((item) {
      print(item['orderStatus']);
      return item['orderStatus'] == status.name;
    }).toList();
    final sortedOrders = orderedItems.toList()
      ..sort((a, b) => b['orderDate'].compareTo(a['orderDate']));
    final reversedList = sortedOrders.reversed.toList();

    return ListView.builder(
      itemCount: reversedList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            final orderStatus = status.name;

            if (orderStatus != OrderStatus.delivered.name) {
              if (orderStatus == OrderStatus.pending.name) {
                // Navigate to Order Details Screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(
                      product: Product(
                        name: orderedItems[index]['orderItems'].first['name'],
                        price: orderedItems[index]['orderItems'].first['price'],
                        details:
                            orderedItems[index]['orderItems'].first['details'],
                        imageUrl:
                            orderedItems[index]['orderItems'].first['imageUrl'],
                        category: mapCategory[orderedItems[index]['orderItems']
                            .first['category']]!,
                        shopId: orderedItems[index]['shopId'],
                        productId: orderedItems[index]['productId'],
                        discountedPrice: snapshot.data!
                            .docs[index]['orderItems'].first['discountedPrice'],
                      ),
                      orderId: orderedItems[index]['orderId'],
                      shopId: orderedItems[index]['shopId'],
                      orderStatus: orderStatus,
                      quantity: orderedItems[index]['quantity'],
                      totalPrice: orderedItems[index]['totalPrice'],
                    ),
                  ),
                );
              } else {
                // Navigate to Product Screen (existing logic)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      product: Product(
                        name: orderedItems[index]['orderItems'].first['name'],
                        price: orderedItems[index]['orderItems'].first['price'],
                        details:
                            orderedItems[index]['orderItems'].first['details'],
                        imageUrl:
                            orderedItems[index]['orderItems'].first['imageUrl'],
                        category: mapCategory[orderedItems[index]['orderItems']
                            .first['category']]!,
                        shopId: orderedItems[index]['shopId'],
                        productId: orderedItems[index]['productId'],
                        discountedPrice: snapshot.data!
                            .docs[index]['orderItems'].first['discountedPrice'],
                      ),
                    ),
                  ),
                );
              }
            } else {
              // Navigate to products screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    product: Product(
                      name: orderedItems[index]['orderItems'].first['name'],
                      price: orderedItems[index]['orderItems'].first['price'],
                      details:
                          orderedItems[index]['orderItems'].first['details'],
                      imageUrl:
                          orderedItems[index]['orderItems'].first['imageUrl'],
                      category: mapCategory[
                          orderedItems[index]['orderItems'].first['category']]!,
                      shopId: orderedItems[index]['shopId'],
                      productId: orderedItems[index]['productId'],
                      discountedPrice: snapshot.data!.docs[index]['orderItems']
                          .first['discountedPrice'],
                    ),
                  ),
                ),
              );
            }
          },
          child: AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              child: OrderItemCard(
                productId: orderedItems[index]['productId'],
                imageUrl:
                    orderedItems[index]['orderItems'].first['imageUrl'].first,
                title: orderedItems[index]['orderItems'].first['name'],
                price: orderedItems[index]['totalPrice'],
                quantity: 1,
                orderStatus: orderedItems[index]['orderStatus'],
                orderId: orderedItems[index]['orderId'],
              ),
            ),
          ),
        );
      },
    );
  }
}
