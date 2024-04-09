import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
                      padding: EdgeInsets.all(8.sp),
                      child: Container(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 4 / 4,
                            autoPlay: false,
                            enlargeCenterPage: false,
                          ),
                          items: widget.product.imageUrl.map((imgUrl) {
                            return Builder(
                              builder: (context) {
                                return CachedNetworkImage(
                                  imageUrl: imgUrl,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.white,
                                    child: Container(),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Row(
                            children: [
                              Text(
                                "\$${widget.product.discountedPrice}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                "\$${widget.product.price}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 11.sp,
                                      color: ColorsManager.hintTextColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationStyle: TextDecorationStyle.wavy,
                                      decorationColor: ColorsManager.blackColor,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            "Description",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 12.sp),
                          ),
                          Text(widget.product.details),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 14.sp),
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
                                                SizedBox(
                                                  width: 60.w,
                                                  child: Text(
                                                    snapshot.data!["name"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            fontSize: 14.sp),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 60.w,
                                                  child: Text(
                                                    snapshot.data!["location"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: ColorsManager
                                                                .hintTextColor),
                                                  ),
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
