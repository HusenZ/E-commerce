import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RowOfProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final VoidCallback onTap;
  const RowOfProductCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.price,
    required this.image,
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
              width: 35.w,
              color: ColorsManager.whiteColor,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    height: 30.h,
                    width: 35.w,
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(1), BlendMode.dstATop),
                          image: NetworkImage(image)),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(160, 3, 115, 244),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          text: TextSpan(
                            text: title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorsManager.whiteColor),
                          ),
                        ),
                        Text(
                          "\$$price",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: ColorsManager.whiteColor),
                        ),
                      ],
                    ),
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
