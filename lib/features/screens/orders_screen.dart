import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/config/routes/routes_manager.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/connectivity_helper.dart';
import 'package:daprot_v1/domain/model/order_models.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/widgets/cart_screen_widget/cart_card.dart';

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.primaryColor,
        title: const Text("My Orders"),
        bottom: TabBar(
          unselectedLabelColor: ColorsManager.whiteColor,
          labelColor: ColorsManager.accentColor,
          labelStyle:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12.sp),
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

    return ListView.builder(
      itemCount: orderedItems.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
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
                          .first['discountedPrice']),
                ),
              ),
            );
          },
          child: OrderItemCard(
            productId: orderedItems[index]['productId'],
            imageUrl: orderedItems[index]['orderItems'].first['imageUrl'].first,
            title: orderedItems[index]['orderItems'].first['name'],
            price: orderedItems[index]['totalPrice'],
            quantity: 1,
            orderStatus: orderedItems[index]['orderStatus'],
          ),
        );
      },
    );
  }
}


// SliverList.builder(
                    //   itemCount: snapshot.data!.docs.length,
                    //   itemBuilder: (context, index) {
                    //     return InkWell(
                    //       onTap: () {
                   
                    //       },
                    //       child: OrderItemCard(
                    //         productId: snapshot.data!.docs[index]['productId'],
                    //         imageUrl: snapshot.data!.docs[index]['orderItems']
                    //             .first['imageUrl'].first,
                    //         title: snapshot
                    //             .data!.docs[index]['orderItems'].first['name'],
                    //         price: snapshot.data!.docs[index]['totalPrice'],
                    //         quantity: itemQuantity,
                    //         orderStatus: snapshot.data!.docs[index]
                    //             ['orderStatus'],
                    //       ),
                    //     );
                    //   },
                    // ),