import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/features/widgets/common_widgets/Delevated_button.dart';
import 'package:daprot_v1/features/widgets/product_s_widget/row_procuts.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(product.imageUrl),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(product.details),
                  Text(
                    "\$${product.price.toString()}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  DelevatedButton(text: 'Add to Cart', onTap: () {}),
                  DelevatedButton(
                    onTap: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(209, 235, 37, 37),
                      foregroundColor: ColorsManager.whiteColor,
                      elevation: 5,
                    ),
                    text: "Add to wishlist",
                  ),
                  const Divider(),
                  Text(
                    "Shop name and address",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  RowOfProduct(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
