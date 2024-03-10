import 'package:daprot_v1/data/dummy_data/data_set.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TredingProducts extends StatelessWidget {
  const TredingProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: 37.h,
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Treding Products",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) => RowOfProductCard(
                    product: products[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductScreen(product: products[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
