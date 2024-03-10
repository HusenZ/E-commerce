import 'package:daprot_v1/data/dummy_data/data_set.dart';
import 'package:daprot_v1/features/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class RowOfProduct extends StatelessWidget {
  const RowOfProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37.h,
      width: double.infinity,
      child: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: products.length,
            itemBuilder: (context, index) =>
                RowOfProductCard(product: products[index], onTap: () {}),
          ),
        ],
      ),
    );
  }
}
