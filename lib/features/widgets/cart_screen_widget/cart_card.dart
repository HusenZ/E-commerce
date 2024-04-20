import 'package:daprot_v1/config/routes/routes_manager.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/domain/connectivity_helper.dart';
import 'package:daprot_v1/domain/model/order_models.dart';
import 'package:daprot_v1/domain/order_repo.dart';
import 'package:daprot_v1/features/widgets/cart_screen_widget/rating_dailogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class CartItemCard extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final String price;
  final OrderModel orderModel;
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
    required this.orderModel,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int _quantity;
  String? orderId;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    repo.getOrderId().then((value) {
      setState(() {
        orderId = value;
      });
    });
  }

  UserOrderRepository repo = UserOrderRepository();

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 12.sp,
                          color: ColorsManager.blackColor,
                        ),
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "${'\u{20B9}'}${(double.parse(widget.price) * _quantity).toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 14.sp,
                          color: ColorsManager.blackColor,
                        ),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
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
                  ),

                  SizedBox(height: 2.h),
                  // Buy Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the checkout screen
                      int total = int.parse(widget.price) * _quantity;
                      ConnectivityHelper.naviagte(
                        context,
                        Routes.checkout,
                        args: {
                          "imageUrl": widget.imageUrl,
                          "title": widget.title,
                          "quantity": _quantity,
                          "price": total.toString(),
                          "orderModel": widget.orderModel,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.secondaryColor,
                      foregroundColor: ColorsManager.offWhiteColor,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    child: Text(
                      'CheckOut',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: ColorsManager.whiteColor,
                          ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ),
    );
  }
}

class OrderItemCard extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final String price;
  final int quantity;
  final String orderStatus;

  const OrderItemCard({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.orderStatus,
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
    double existingRating = 0.0;
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
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 12.sp, color: ColorsManager.blackColor),
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "${'\u{20B9}'}${(double.parse(widget.price) * _quantity).toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 14.sp, color: ColorsManager.blackColor),
                    overflow: TextOverflow.fade,
                  ),
                  if (widget.orderStatus != OrderStatus.delivered.name)
                    Card(
                      child: Text(
                        widget.orderStatus,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: ColorsManager.secondaryColor,
                            ),
                      ),
                    ),
                  if (widget.orderStatus == OrderStatus.delivered.name)
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => RatingDialog(
                            initialRating: existingRating,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          RatingBar.builder(
                            initialRating: existingRating,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 24,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              showDialog(
                                context: context,
                                builder: (context) => RatingDialog(
                                  initialRating: existingRating,
                                ),
                              );
                            },
                          ),
                          // You can add more widgets here, such as text indicating the rating
                        ],
                      ),
                    )
                ],
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ),
    );
  }
}
