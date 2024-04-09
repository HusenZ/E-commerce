import 'package:daprot_v1/config/theme/colors_manager.dart';
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

  const ShopCard({
    super.key,
    required this.shopLogoPath,
    required this.shopBannerPath,
    required this.shopName,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Stack(
        children: [
          // Background Banner Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              shopBannerPath,
              fit: BoxFit.cover,
              height: 25.h,
              width: 99.w,
            ),
          ),
          // Shop Logo on top of Banner
          Positioned(
            top: 1.h,
            left: 2.w,
            child: CircleAvatar(
              radius: 20.sp,
              backgroundColor: ColorsManager.offWhiteColor,
              child: CircleAvatar(
                radius: 18.sp,
                backgroundImage: NetworkImage(
                  shopLogoPath,
                ),
              ),
            ),
          ),
          // Content Container with rounded corners
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name
                  Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Timings & Location Row
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text("$openTime - $closeTime")
                    ],
                  ),

                  const SizedBox(width: 4.0),
                  SizedBox(
                      width: 80.w,
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(height: 8.0),
                  // Ratings Row
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16.0, color: Colors.amber),
                      Text("$rating"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
