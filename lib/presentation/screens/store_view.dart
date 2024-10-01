import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/data/repository/shop_data_repo.dart';
import 'package:gozip/presentation/screens/product_details_screen.dart';
import 'package:gozip/presentation/widgets/product_s_widget/expandable_text.dart';
import 'package:gozip/presentation/widgets/product_s_widget/row_procuts.dart';
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
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: snapshot.data!["shopImage"],
                        fit: BoxFit.fill,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.5),
                            end: Alignment.center,
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: CircleAvatar(
                    radius: 20.sp,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!["shopLogo"],
                      ),
                      backgroundColor: Colors.white,
                      radius: 18.sp,
                    ),
                  ),
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                ),
                floating: true,
                pinned: true,
                stretch: true,
                stretchTriggerOffset: 20.h,
                onStretchTrigger: () {
                  // Function callback for stretch
                  return Future<void>.value();
                },
                expandedHeight: 22.h,
                backgroundColor: Colors.white,
                // bottom: PreferredSize(
                //   preferredSize: Size.fromHeight(2.h),
                //   child: CircleAvatar(
                //     radius: 27.sp,
                //     backgroundColor: Colors.white,
                //     child: CircleAvatar(
                //       backgroundImage: NetworkImage(snapshot.data!["shopLogo"]),
                //       backgroundColor: Colors.white,
                //       radius: 25.sp,
                //     ),
                //   ),
                // ),
              ),
              BottomTitle(
                shopName: snapshot.data!["name"],
                openTime: snapshot.data!["openTime"],
                closeTime: snapshot.data!["closeTime"],
                locaion: snapshot.data!["location"],
                description: snapshot.data!["description"].toString().trim(),
              ),
              StreamBuilder(
                  stream: repository.getShopProductStream(sellerId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No products available'),
                        ),
                      );
                    }
                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.9,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          DocumentSnapshot product = snapshot.data!.docs[index];
                          return StoreViewProductCard(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      product: Product(
                                        name: product['name'],
                                        price: product['price'],
                                        details: product['name'],
                                        imageUrl: product['selectedPhotos'],
                                        category:
                                            mapCategory[product['category']]!,
                                        shopId: product['shopId'],
                                        productId: product['productId'],
                                        discountedPrice:
                                            product['discountedPrice'],
                                      ),
                                    ),
                                  ));
                            },
                            title: product['name'],
                            price: product['discountedPrice'],
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
  final String description;
  const BottomTitle(
      {super.key,
      required this.shopName,
      required this.description,
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
              Padding(
                padding: EdgeInsets.only(left: 2.sp),
                child: Icon(
                  Icons.location_on,
                  size: 2.h,
                  color: const Color.fromARGB(255, 3, 140, 244),
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              SizedBox(
                width: 90.w,
                child: Text(
                  locaion,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 10.sp,
                      color: const Color.fromARGB(146, 87, 92, 99)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[400]!, width: 0.5),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About:",
                    style: TextStyle(
                      color: const Color.fromARGB(146, 120, 117, 117),
                      fontSize: 12.sp,
                    ),
                  ),
                  ExpandableText(
                    description,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Time: ',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp,
                    color: const Color.fromARGB(255, 3, 140, 244)),
              ),
              Text(
                openTime,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp,
                    color: const Color.fromARGB(255, 3, 140, 244)),
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
        ],
      )
    ]);
  }
}
