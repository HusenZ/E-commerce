import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/domain/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartItemCard extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final String price;
  final int quantity;
  final Function(String, int) onBuyPressed;

  const CartItemCard({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onBuyPressed,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int _quantity; // Define _quantity as a state variable

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity; // Initialize _quantity in initState
  }

  void _confirmPurchase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: const Text('Are you sure you want to purchase this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onBuyPressed(
                  (double.parse(widget.price) * _quantity).toStringAsFixed(2),
                  _quantity,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  UserOrderRepository repo = UserOrderRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: repo.getOrderStatusStream(widget.productId),
        builder: (context, snapshot) {
          final orderStatus = snapshot.data;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.sp),
                    child: Image.network(
                      widget.imageUrl,
                      width: 15.h,
                      height: 15.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 12.sp,
                                  color: ColorsManager.blackColor),
                          overflow: TextOverflow.fade,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "${'\u{20B9}'}${(double.parse(widget.price) * _quantity).toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 14.sp,
                                  color: ColorsManager.blackColor),
                          overflow: TextOverflow.fade,
                        ),
                        orderStatus == null
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () {
                                      setState(() {
                                        _quantity -= 1;
                                      });
                                    },
                                  ),
                                  Text('$_quantity'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    onPressed: () {
                                      setState(() {
                                        _quantity += 1;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Card(
                                child: Text(
                                  snapshot.data!.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: ColorsManager.secondaryColor,
                                      ),
                                ),
                              ),
                        SizedBox(height: 2.h),
                        // Buy Button
                        orderStatus == null
                            ? ElevatedButton(
                                onPressed: () => _confirmPurchase(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorsManager.secondaryColor,
                                    foregroundColor:
                                        ColorsManager.offWhiteColor,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge),
                                child: const Text('Buy'),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          );
        });
  }
}

class OrderItemCard extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final String price;
  final int quantity;

  const OrderItemCard({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  State<OrderItemCard> createState() => OrderItemCardState();
}

class OrderItemCardState extends State<OrderItemCard> {
  late int _quantity; // Define _quantity as a state variable

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity; // Initialize _quantity in initState
  }

  UserOrderRepository repo = UserOrderRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: repo.getOrderStatusStream(widget.productId),
        builder: (context, snapshot) {
          final orderStatus = snapshot.data;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.sp),
                    child: Image.network(
                      widget.imageUrl,
                      width: 15.h,
                      height: 15.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 12.sp,
                                  color: ColorsManager.blackColor),
                          overflow: TextOverflow.fade,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "${'\u{20B9}'}${(double.parse(widget.price) * _quantity).toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 14.sp,
                                  color: ColorsManager.blackColor),
                          overflow: TextOverflow.fade,
                        ),
                        Card(
                          child: Text(
                            orderStatus!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: ColorsManager.secondaryColor,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          );
        });
  }
}
