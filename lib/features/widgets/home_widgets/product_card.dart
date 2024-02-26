import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  final int index;
  final List<Product> products;
  const ProductCard({
    super.key,
    required this.index,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 4.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.sp),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            height: 30.h,
            width: 90.w,
            color: ColorsManager.whiteColor,
            child: Row(
              children: [
                Container(
                  height: 30.h,
                  width: 35.w,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Image.asset(
                    products[index].imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  children: [
                    Text(
                      products[index].name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "\$${products[index].price}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      products[index].details,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        foregroundColor: ColorsManager.whiteColor,
                      ),
                      child: const Text("Add To Cart"),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.greyColor,
                          foregroundColor: ColorsManager.whiteColor,
                        ),
                        child: const Text("View Details")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
