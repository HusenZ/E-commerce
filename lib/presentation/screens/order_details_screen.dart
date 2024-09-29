import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/domain/entities/order_models.dart';
import 'package:gozip/domain/repository/order_repo.dart';
import 'package:gozip/presentation/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip/presentation/widgets/order_widgets/bottom_sheet_cancel.dart';
import 'package:gozip/presentation/widgets/order_widgets/product_details_card.dart';
import 'package:gozip/presentation/widgets/order_widgets/user_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Product product;
  final String orderStatus;
  final String quantity;
  final String orderId;
  final String shopId;
  final String totalPrice;
  const OrderDetailsScreen({
    super.key,
    required this.product,
    required this.orderId,
    required this.shopId,
    required this.orderStatus,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // OrderStatus _selectedStatus = OrderStatus.pending;
  final UserOrderRepository _userOrderRepository = UserOrderRepository();
  bool? _hasReason;

  void _showCancelOrderBottomSheet(
      BuildContext context, Function(String) onCancelSelected) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            CancelOrderBottomSheet(onCancelSelected: onCancelSelected));
  }

  @override
  void initState() {
    super.initState();
    _hasCancellationReason().then(
      (value) {
        setState(() {
          _hasReason = value;
        });
      },
    );
  }

  Future<bool> _hasCancellationReason() async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection('orders')
        .where('orderId', isEqualTo: widget.orderId)
        .limit(1);
    final snapshot = await docRef.get();

    // Check if a document was found
    if (snapshot.docs.isEmpty) {
      return false; // No document found for the order ID
    }

    final orderDoc = snapshot.docs[0];

    return orderDoc.data().containsKey('cancellationReason');
  }

  @override
  Widget build(BuildContext context) {
    bool nonNullHasRea = _hasReason ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderStatus.toUpperCase()),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const UserDetailsCard(),
              SizedBox(height: 12.sp),
              ProductDetailsCard(
                product: widget.product,
                quantity: widget.quantity,
                totalPrice: widget.totalPrice,
              ),
              SizedBox(height: 12.sp),
              if (nonNullHasRea &&
                  widget.orderStatus == OrderStatus.pending.name)
                Card(
                  color: const Color.fromARGB(237, 254, 76, 76),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Text(
                      "Cancellation Request has been sent",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 12.sp, color: ColorsManager.whiteColor),
                    ),
                  ),
                ),
              if (!nonNullHasRea)
                ElevatedButton(
                  onPressed: () async {
                    _showCancelOrderBottomSheet(
                      context,
                      (reason) {
                        print("Reason For cancellation ----> $reason");
                        LoadingDialog.showLoaderDialog(context);
                        _userOrderRepository
                            .requestCancel(
                                widget.orderId, widget.shopId, reason)
                            .then(
                          (value) {
                            Navigator.pushReplacementNamed(
                                context, Routes.ordersRoute);
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.accentColor),
                  child: Text(
                    "Request For Cancellation ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 9.5.sp,
                          color:
                              widget.orderStatus == OrderStatus.cancelled.name
                                  ? Colors.red
                                  : Colors.white,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
