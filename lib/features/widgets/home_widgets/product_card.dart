import 'package:daprot_v1/bloc/cart_bloc/cart_bloc.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  final double height;
  final double width;
  final Product product;
  final VoidCallback onTap;
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.height,
    required this.width,
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
              height: height,
              width: width,
              color: ColorsManager.whiteColor,
              child: Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 35.w,
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: ColorsManager.hintTextColor),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context)
                              .add(AddToCart(product));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primaryColor,
                          foregroundColor: ColorsManager.whiteColor,
                        ),
                        child: const Text("Add To Cart"),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(206, 233, 226, 226),
                            foregroundColor: ColorsManager.blackColor,
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
