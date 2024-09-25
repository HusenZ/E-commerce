import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gozip/bloc/cart_bloc/cart_bloc.dart';
import 'package:gozip/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:gozip/bloc/wish_list_bloc/wish_list_state.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/utils/check_cart_repo.dart';
import 'package:gozip/utils/rating_repo.dart';
import 'package:gozip/utils/shop_data_repo.dart';
import 'package:gozip/utils/wish_list_repo.dart';
import 'package:gozip/presentation/screens/cart_screen.dart';
import 'package:gozip/presentation/screens/store_view.dart';
import 'package:gozip/presentation/widgets/common_widgets/delevated_button.dart';
import 'package:gozip/presentation/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip/presentation/widgets/common_widgets/snack_bar.dart';
import 'package:gozip/presentation/widgets/product_s_widget/reviews_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartAddSuccessState) {
              customSnackBar(context, 'Added Successfully', true);
            }
          },
        ),
        BlocListener<WishlistBloc, WishlistState>(
          listener: (context, state) {
            if (state is WishListLoading) {
              LoadingDialog.showLoaderDialog(context);
            }
            if (state is WishListSuccess) {
              Navigator.of(context).pop();
              customSnackBar(context, 'Added To Wish List', true);
            }
            if (state is ItemExists) {
              print("State is here ");
              Navigator.of(context).pop();
              customSnackBar(context, 'Already Wish Listed', false);
            }
          },
        ),
      ],
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
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ));
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                      // IconButton(
                      //   onPressed: () async {
                      //     await shareProduct(widget.product.productId);
                      //   },
                      //   icon: const Icon(Icons.share),
                      // ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: AnimationConfiguration.synchronized(
                        child: SlideAnimation(
                          duration: const Duration(milliseconds: 375),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 4 / 4,
                              autoPlay: false,
                              enlargeCenterPage: false,
                              scrollPhysics: const BouncingScrollPhysics(),
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
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.sp),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          FutureBuilder(
                            future: RatingRepo.getProductsAvgRating(
                                widget.product.productId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              if (snapshot.hasData) {
                                return Text(snapshot.data!);
                              } else {
                                return Text('');
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimationConfiguration.synchronized(
                        child: SlideAnimation(
                          duration: const Duration(milliseconds: 375),
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
                                    "₹${widget.product.discountedPrice}",
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
                                    "₹${widget.product.price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 11.sp,
                                          color: ColorsManager.hintTextColor,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationStyle:
                                              TextDecorationStyle.wavy,
                                          decorationColor:
                                              ColorsManager.blackColor,
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
                              // Wish List Button
                              StreamBuilder<bool>(
                                  stream: WishListRepo().isProductWishlisted(
                                      widget.product.productId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: 4.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.sp),
                                            gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 185, 183, 183),
                                                  Colors.white
                                                ])),
                                      );
                                    }
                                    if (snapshot.data != null) {
                                      if (snapshot.data!) {
                                        return SizedBox(
                                          width: 90.w,
                                          height: 4.h,
                                          child: Center(
                                            child: DefaultTextStyle(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: ColorsManager
                                                          .lightRedColor,
                                                      fontSize: 12.sp),
                                              child: AnimatedTextKit(
                                                animatedTexts: [
                                                  FadeAnimatedText('Your'),
                                                  FadeAnimatedText(
                                                      'Your Favourite Product!!'),
                                                  FadeAnimatedText(
                                                      'Let It Come To You'),
                                                ],
                                                onTap: () {
                                                  print("Tap Event");
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return DelevatedButton(
                                          onTap: () {
                                            LoadingDialog.showLoaderDialog(
                                                context);
                                            WishListRepo()
                                                .addToWishList(
                                                    widget.product.productId)
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    209, 192, 70, 201),
                                            foregroundColor:
                                                ColorsManager.whiteColor,
                                            elevation: 5,
                                          ),
                                          text: "Add to wishlist",
                                        );
                                      }
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
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
                                                sellerId:
                                                    widget.product.shopId),
                                          ));
                                    },
                                    child: Material(
                                      elevation: 1.h,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
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
                                                      snapshot
                                                          .data!["location"],
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
                                },
                              ),
                              const Divider(),
                              Text(
                                "Reviews",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              // Build some reviews UI
                              ReviewWidget(productId: widget.product.productId)
                            ],
                          ),
                        ),
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
