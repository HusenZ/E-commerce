import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class RowOfProduct extends StatelessWidget {
  const RowOfProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      width: double.infinity,
      child: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemBuilder: (context, index) => Container(
              width: 10.w,
              decoration: const BoxDecoration(color: ColorsManager.greyColor),
              child: Text('products'),
            ),
          ),
        ],
      ),
    );
  }
}
