import 'package:daprot_v1/data/dummy_data/data_set.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DisplayProduct extends StatelessWidget {
  final String selectedOption;
  const DisplayProduct({
    Key? key,
    required this.selectedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter products based on the selected category option
    List<Product> filteredProducts = selectedOption == "All"
        ? products // Show all products if "all" category is selected
        : products
            .where((product) =>
                product.category.toString().split('.').last ==
                selectedOption.toLowerCase())
            .toList();

    return SliverList.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          height: 30.h,
          width: 90.w,
          product: filteredProducts[index],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ProductScreen(product: filteredProducts[index]),
              ),
            );
          },
        );
      },
    );
  }
}
