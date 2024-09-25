import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/utils/rating_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShopCard extends StatelessWidget {
  final String shopLogoPath;
  final String shopBannerPath;
  final String shopName;
  final String openTime;
  final String closeTime;
  final String location;
  final double rating;
  final String shopId;
  final String address;

  const ShopCard({
    super.key,
    required this.shopLogoPath,
    required this.address,
    required this.shopBannerPath,
    required this.shopName,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.rating,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
        elevation: 4.0,
        child: Stack(
          children: [
            // Background Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: Image.network(
                shopBannerPath,
                fit: BoxFit.fill,
                height: 22.h,
                width: 99.w,
              ),
            ),
            // Shop Logo on top of Banner

            // Content Container with rounded corners
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 8.h,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(220, 169, 75, 232),
                      Color.fromARGB(195, 255, 255, 255),
                    ])),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Name
                      Text(
                        shopName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.whiteColor,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      // Timings & Location Row
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 16.0,
                            color: ColorsManager.whiteColor,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "$openTime - $closeTime",
                            style: const TextStyle(
                              color: ColorsManager.whiteColor,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          // Ratings Row
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 16.sp, color: Colors.amber),
                              FutureBuilder(
                                future: RatingRepo.getShopRating(shopId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox();
                                  }
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                        color: ColorsManager.whiteColor,
                                      ),
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(width: 1.h),
                      SizedBox(
                          width: 80.w,
                          child: Text(
                            address,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ColorsManager.whiteColor,
                            ),
                          )),
                      SizedBox(
                          width: 80.w,
                          child: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ColorsManager.whiteColor,
                            ),
                          )),
                      SizedBox(height: 8.sp),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 1.h,
              left: 2.w,
              child: CircleAvatar(
                radius: 22.sp,
                backgroundColor: ColorsManager.offWhiteColor,
                child: CircleAvatar(
                  radius: 18.sp,
                  backgroundImage: NetworkImage(
                    shopLogoPath,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
