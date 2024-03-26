import 'package:daprot_v1/bloc/cart_bloc/cart_bloc.dart';
import 'package:daprot_v1/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/check_cart_repo.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/cart_screen.dart';
import 'package:daprot_v1/features/screens/store_view.dart';
import 'package:daprot_v1/features/widgets/common_widgets/Delevated_button.dart';
import 'package:daprot_v1/features/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final CheckRepo cartRepo = CheckRepo();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartAddSuccessState) {
          customSnackBar(context, 'Added Successfully', true);
        }
      },
      child: StreamBuilder(
          stream: cartRepo.checkCart(widget.product.productId),
          initialData: false,
          builder: (context, snapshot) {
            final _exists = snapshot.data ?? false;
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: ColorsManager.primaryColor,
                    title: Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ColorsManager.whiteColor, fontSize: 16.sp),
                    ),
                    floating: true,
                    pinned: true,
                    actions: [
                      IconButton.filled(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ));
                          },
                          icon: const Icon(Icons.shopping_cart_outlined))
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(widget.product.imageUrl),
                          Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(widget.product.details),
                          Text(
                            "\$${widget.product.price}",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          DelevatedButton(
                              text: _exists ? 'Go To Cart' : 'Add to Cart',
                              onTap: _exists
                                  ? () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(),
                                        ),
                                      );
                                    }
                                  : () {
                                      BlocProvider.of<CartBloc>(context)
                                          .add(AddToCart(widget.product));
                                    }),
                          DelevatedButton(
                            onTap: () {
                              BlocProvider.of<WishlistBloc>(context).add(
                                  AddProductEvent(product: widget.product));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(209, 235, 37, 37),
                              foregroundColor: ColorsManager.whiteColor,
                              elevation: 5,
                            ),
                            text: "Add to wishlist",
                          ),
                          const Divider(),
                          Text(
                            "Shop Details",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          StreamBuilder(
                              stream: ProductStream()
                                  .getShopStream(widget.product.shopId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 17.w,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoreView(
                                              sellerId: widget.product.shopId),
                                        ));
                                  },
                                  child: Material(
                                    elevation: 1.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      child: Container(
                                        color: ColorsManager.whiteColor,
                                        padding: EdgeInsets.all(2.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 35.sp,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!['shopLogo']),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!["name"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                Text(
                                                  snapshot.data!["location"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: ColorsManager
                                                              .hintTextColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
