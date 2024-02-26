import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/dummy_data/data_set.dart';
import 'package:daprot_v1/features/widgets/home_widgets/location_widget.dart';
import 'package:daprot_v1/features/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:daprot_v1/features/widgets/home_widgets/banner_ads.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.sp),
                bottomRight: Radius.circular(40.sp),
              ),
            ),
            expandedHeight: 15.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "\"Shop in your city\"",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      color: ColorsManager.whiteColor,
                    ),
              ),
              expandedTitleScale: 1,
              //background
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0),
                      child: LocationWidget(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextField(
                          enabled: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.sp),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: ColorsManager.whiteColor,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: ColorsManager.whiteColor,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                  Icons.filter_list,
                                  color: ColorsManager.primaryColor,
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(1.w),
                            border: InputBorder.none,
                            hintText: "Search Here",
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: ColorsManager.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.parallax,
              centerTitle: true,
              titlePadding: const EdgeInsets.all(8.0),
            ),
            centerTitle: true,
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            sliver: SliverToBoxAdapter(
              child: BannerAds(),
            ),
          ),
          SliverList.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                index: index,
                products: products,
              );
            },
          ),
        ],
      ),
    );
  }
}
