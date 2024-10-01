import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/data/repository/rating_repo.dart';
import 'package:gozip/data/repository/shop_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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

class _HomeProductCardState extends State<HomeProductCard>
    with TickerProviderStateMixin {
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

    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 8.sp, top: 3.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.sp),
          child: Container(
            padding: EdgeInsets.only(left: 9.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ],
                color: Colors.white),
            // color: ColorsManager.whiteColor,
            child: Stack(
              children: [
                Hero(
                  tag: widget.product.imageUrl.first,
                  child: Container(
                    height: 21.5.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.product.imageUrl.first,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 21.5.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹${widget.product.discountedPrice}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 12.sp),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            "₹${widget.product.price}",
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 12.sp,
                                      color: ColorsManager.accentColor,
                                    ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                if (discountPercentage > 10)
                  Positioned(
                    top: 0,
                    right: 2.w,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsManager
                            .secondaryColor, // Example ribbon color
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.sp),
                          topRight: Radius.circular(8.sp),
                        ),
                      ),
                      child: Text(
                        '${discountPercentage.toStringAsFixed(0)}% OFF',
                        style: TextStyle(color: Colors.white, fontSize: 10.sp),
                      ),
                    ),
                  ),
                Positioned(
                  top: 19.h,
                  left: 28.w,
                  child: FutureBuilder(
                    future: RatingRepo.getProductsAvgRating(
                        widget.product.productId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      if (snapshot.hasData) {
                        return Container(
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(185, 146, 75, 232),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 12.sp,
                              ),
                              Text(
                                snapshot.data!,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
