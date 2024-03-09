import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
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
                      product.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "\$${product.price}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        product.details,
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
      ),
    );
  }
}
