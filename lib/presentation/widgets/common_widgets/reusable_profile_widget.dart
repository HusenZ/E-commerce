import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/presentation/widgets/common_widgets/single_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DcardOfProfile extends StatelessWidget {
  const DcardOfProfile({
    super.key,
    required this.title,
    required this.title2,
    required this.image1,
    required this.image2,
    required this.onPressed1,
    required this.onPressed2,
  });

  final String title;
  final String title2;
  final String image1;
  final String image2;
  final Function()? onPressed1;
  final Function()? onPressed2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      width: 90.w,
      decoration: BoxDecoration(
          color: ColorsManager.lightGrey,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: onPressed1,
              child: DsingleChildCard(title: title, image: image1)),
          InkWell(
              onTap: onPressed2,
              child: DsingleChildCard(title: title2, image: image2)),
        ],
      ),
    );
  }
}
