import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:flutter/material.dart';
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
                      product.imageUrl.first,
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
                      SizedBox(
                        width: 30.w,
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "\$${product.price}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          product.details,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: ColorsManager.hintTextColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: onTap,
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

class HomeProductCard extends StatefulWidget {
  final double height;
  final double width;
  final Product product;
  final VoidCallback onTap;
  const HomeProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.height,
    required this.width,
  });

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard> {
  String? shopName;
  double calculateDiscountPercentage(
      double originalPrice, double discountedPrice) {
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double originalPrice = double.parse(widget.product.price);
    double discountedPrice = double.parse(widget.product.discountedPrice);
    ProductStream stream = ProductStream();

    double discountPercentage =
        calculateDiscountPercentage(originalPrice, discountedPrice);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Material(
          elevation: 4.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.sp),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: widget.height,
              width: widget.width,
              color: ColorsManager.whiteColor,
              child: Stack(
                children: [
                  Container(
                    height: 20.h,
                    width: 40.w,
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Image.network(
                      widget.product.imageUrl.first,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 18.5.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30.w,
                          child: Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "\$${widget.product.discountedPrice}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 12.sp),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "\$${widget.product.price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: ColorsManager.hintTextColor,
                                    fontSize: 12.sp,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                            stream: stream.fetchShopName(widget.product.shopId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                shopName = snapshot.data!['name'];
                              } else {
                                {
                                  shopName = "";
                                }
                              }
                              return SizedBox(
                                width: 40.w,
                                child: Text(
                                  shopName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 12.sp,
                                          color: const Color.fromARGB(
                                              255, 3, 103, 244)),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(
                            255, 54, 101, 244), // Example ribbon color
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(8)),
                      ),
                      child: Text(
                        '${discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
