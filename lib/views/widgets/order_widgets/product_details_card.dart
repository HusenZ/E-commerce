import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/data/product.dart';
import 'package:gozip/views/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductDetailsCard extends StatelessWidget {
  final Product product;
  final String quantity;
  final String totalPrice;

  const ProductDetailsCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProductScreen(product: product),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Display product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl.first,
                  width: 26.w,
                  height: 15.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 3,
                      textDirection: TextDirection.ltr,
                      softWrap: true,
                      text: TextSpan(
                        text: product.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 12.sp,
                              color: ColorsManager.blackColor,
                            ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text('Price: ₹${product.price}'),
                    SizedBox(height: 1.h),
                    Text('After discount: ₹${product.discountedPrice}'),
                    SizedBox(height: 1.h),
                    Text('Quantity: $quantity'),
                    SizedBox(height: 1.h),
                    Text('Total: ₹$totalPrice'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//order.orderItems.first.name,