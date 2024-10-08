import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/widgets/product_s_widget/row_procuts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class StoreView extends StatelessWidget {
  final ProductStream repository = ProductStream();
  final String sellerId;

  StoreView({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: repository.getShopStream(sellerId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('No data available');
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: snapshot.data!["shopImage"],
                    fit: BoxFit.cover,
                  ),
                ),
                floating: false,
                pinned: false,
                expandedHeight: 20.h,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(2.h),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!["shopLogo"]),
                    backgroundColor: Colors.white,
                    radius: 25.sp,
                  ),
                ),
              ),
              BottomTitle(
                  shopName: snapshot.data!["name"],
                  openTime: snapshot.data!["openTime"],
                  closeTime: snapshot.data!["closeTime"],
                  locaion: snapshot.data!["location"]),
              StreamBuilder(
                  stream: repository.getProductStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('No products available'),
                        ),
                      );
                    }
                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          DocumentSnapshot product = snapshot.data!.docs[index];
                          return RowOfProductCard(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      product: Product(
                                        name: product['name'],
                                        price: product['price'],
                                        details: product['name'],
                                        imageUrl:
                                            product['selectedPhotos'].first,
                                        category: Category.men,
                                        shopId: product['shopId'],
                                        productId: product['productId'],
                                      ),
                                    ),
                                  ));
                            },
                            title: product['name'],
                            price: product['price'],
                            image: product['selectedPhotos'].first,
                          );
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    );
                  })
            ],
          );
        },
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String bannerImage;
  final String logo;
  final String shopName;

  const BannerWidget(
      {super.key,
      required this.bannerImage,
      required this.logo,
      required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            image: DecorationImage(
              image: NetworkImage(bannerImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 17.h, left: 15.h, right: 15.h),
                  child: CircleAvatar(
                    radius: 32.sp,
                    backgroundColor: ColorsManager.whiteColor,
                    child: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: CachedNetworkImage(
                      //   imageUrl: logo,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BottomTitle extends StatelessWidget {
  final String shopName;
  final String openTime;
  final String closeTime;
  final String locaion;
  const BottomTitle(
      {super.key,
      required this.shopName,
      required this.openTime,
      required this.closeTime,
      required this.locaion});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      Column(
        children: [
          Text(
            shopName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 15.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locaion,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, color: ColorsManager.greyColor),
              ),
              SizedBox(
                width: 4.w,
              ),
              Icon(
                Icons.location_on,
                size: 2.h,
                color: ColorsManager.greyColor,
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Time: ',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp, color: ColorsManager.accentColor),
              ),
              Text(
                openTime,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp, color: ColorsManager.accentColor),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                "Close Time: ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
              Text(
                closeTime,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      )
    ]);
  }
}
