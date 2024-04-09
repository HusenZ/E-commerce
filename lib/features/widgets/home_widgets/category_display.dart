import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DisplayProduct extends StatelessWidget {
  final String selectedOption;
  const DisplayProduct({
    super.key,
    required this.selectedOption,
  });

  @override
  Widget build(BuildContext context) {
    // Filter products based on the selected category option
    // List<Product> filteredProducts = selectedOption == "All"
    //     ? products // Show all products if "all" category is selected
    //     : products
    //         .where((product) =>
    //             product.category.toString().split('.').last ==
    //             selectedOption.toLowerCase())
    //         .toList();
    ProductStream repo = ProductStream();

    return StreamBuilder(
      stream: repo.getProductStream(),
      builder: (context, snapshot) {
        final product = snapshot.data;
        if (product == null) {
          return const Text("no prodcuts available");
        }
        return SliverList.builder(
            itemCount: product.docs.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: Product(
                    name: product.docs[index]['name'],
                    price: product.docs[index]['price'],
                    details: product.docs[index]['description'],
                    imageUrl: product.docs[index]['selectedPhotos'].first,
                    shopId: product.docs[index]['shopId'],
                    category: mapCategory[product.docs[index]['category']]!,
                    productId: product.docs[index]['productId'],
                    discountedPrice: product.docs[index]['discountedPrice']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        product: Product(
                            name: product.docs[index]['name'],
                            price: product.docs[index]['price'],
                            details: product.docs[index]['description'],
                            imageUrl:
                                product.docs[index]['selectedPhotos'].first,
                            shopId: product.docs[index]['shopId'],
                            category:
                                mapCategory[product.docs[index]['category']]!,
                            productId: product.docs[index]['productId'],
                            discountedPrice: product.docs[index]
                                ['discountedPrice']),
                      ),
                    ),
                  );
                },
                height: 30.h,
                width: 2.h,
              );
            });
      },
    );
  }
}
