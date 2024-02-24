import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

import 'package:daprot_v1/features/widgets/home_widgets/banner_ads.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            expandedHeight: 15.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Daprot",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: "Times",
                      color: ColorsManager.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.all(8.0),
              background: Image.asset(
                "assets/images/dp.png",
                fit: BoxFit.cover,
              ),
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
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.sp),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 12.h,
                    width: 90.w,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
