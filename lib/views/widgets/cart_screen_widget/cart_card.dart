import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/config/routes/routes_manager.dart';
import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/utils/connectivity_helper.dart';
import 'package:gozip/model/order_models.dart';
import 'package:gozip/utils/order_repo.dart';
import 'package:gozip/utils/review_repo.dart';
import 'package:gozip/views/screens/add_review_screen.dart';
import 'package:gozip/views/widgets/common_widgets/delevated_button.dart';
import 'package:gozip/views/widgets/product_s_widget/expandable_text.dart';
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
                  SizedBox(
                    width: 50.w,
                    child: RichText(
                      maxLines: 3,
                      text: TextSpan(
                        text: widget.title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 12.sp,
                              color: ColorsManager.blackColor,
                            ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.h),
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
                          if (_quantity > 1) {
                            setState(() {
                              _quantity -= 1;
                            });
                          }
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

                  SizedBox(height: 0.6.h),
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
  final String orderId;

  const OrderItemCard({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.orderStatus,
    required this.orderId,
  });

  @override
  State<OrderItemCard> createState() => OrderItemCardState();
}

class OrderItemCardState extends State<OrderItemCard> {
  late int _quantity; // Define _quantity as a state Variable(),
  bool? hasReason;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity; // Initialize _quantity in initState
    _hasCancellationReason().then(
      (value) {
        setState(() {
          hasReason = value;
        });
      },
    );
  }

  UserOrderRepository repo = UserOrderRepository();

  Future<bool> _hasCancellationReason() async {
    // Get a reference to the Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Create a query to get the order document
    final docRef = firestore
        .collection('orders')
        .where('orderId', isEqualTo: widget.orderId)
        .limit(1);

    // Get a snapshot of the matching document(s)
    final snapshot = await docRef.get();

    // Check if a document was found
    if (snapshot.docs.isEmpty) {
      return false; // No document found for the order ID
    }

    // Access the first document (assuming there should only be one)
    final orderDoc = snapshot.docs[0];

    // Check if the 'cancellationReason' field exists
    return orderDoc.data().containsKey('cancellationReason');
  }

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
                  SizedBox(
                    width: 50.w,
                    child: RichText(
                      maxLines: 3,
                      text: TextSpan(
                        text: widget.title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 12.sp,
                              color: ColorsManager.blackColor,
                            ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "${'\u{20B9}'}${(double.parse(widget.price) * _quantity).toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 14.sp, color: ColorsManager.blackColor),
                    overflow: TextOverflow.fade,
                  ),
                  if (widget.orderStatus != OrderStatus.delivered.name)
                    hasReason ?? false
                        ? Text(
                            "Requested for Cancellation",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorsManager.lightRedColor),
                          )
                        : Card(
                            color: ColorsManager.whiteColor,
                            child: Text(
                              widget.orderStatus.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 12.sp,
                                    color: widget.orderStatus ==
                                            OrderStatus.cancelled.name
                                        ? const Color.fromARGB(255, 249, 10, 10)
                                        : ColorsManager.secondaryColor,
                                  ),
                            ),
                          ),
                  if (widget.orderStatus == OrderStatus.delivered.name)
                    FutureBuilder(
                        future: ReviewsRepo.getReviews(widget.productId),
                        builder: (context, snapshot) {
                          double? rating;
                          String? review;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == null ||
                              !snapshot.hasData ||
                              snapshot.hasError) {
                            return const Text('Please Review The Product');
                          }
                          if (snapshot.data!.exists == false) {
                            rating = 0.0;
                            return DelevatedButton(
                              text: 'Review',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddReviewScreen(
                                    imageUrl: widget.imageUrl,
                                    name: widget.title,
                                    productId: widget.productId,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.data!.exists) {
                            rating = snapshot.data!['rating'];
                            review = snapshot.data!['review'];
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: rating ?? 0.0,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 24,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              review == null
                                  ? const SizedBox()
                                  : ExpandableText(review)
                            ],
                          );
                        })
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
