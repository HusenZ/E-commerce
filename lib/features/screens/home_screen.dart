import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/features/widgets/home_widgets/category_display.dart';
import 'package:daprot_v1/features/widgets/home_widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:daprot_v1/features/widgets/home_widgets/banner_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedOption = "All";

  Widget _buildFilterSection(double screenWidth) {
    double screenWidth = MediaQuery.of(context).size.width;

    double horizontalMargin = screenWidth * 0.01;
    double verticalMargin = 0.001.w;
    double iconSize = screenWidth * 0.045;
    double borderRadius = screenWidth * 0.04;
    double borderWidth = screenWidth * 0.0025;
    double spacing = screenWidth * 0.02;
    double padding = screenWidth * 0.015;
    double avatarRadius = screenWidth * 0.027;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterOption(context, 'All', Icons.shop, iconSize,
                    borderRadius, borderWidth, spacing, padding, avatarRadius),
                _buildFilterOption(context, 'Men', Icons.boy, iconSize,
                    borderRadius, borderWidth, spacing, padding, avatarRadius),
                _buildFilterOption(context, 'Women', Icons.girl, iconSize,
                    borderRadius, borderWidth, spacing, padding, avatarRadius),
                _buildFilterOption(context, 'Baby', Icons.child_care, iconSize,
                    borderRadius, borderWidth, spacing, padding, avatarRadius),
                _buildFilterOption(
                    context,
                    'Cosmetic',
                    Icons.style_outlined,
                    iconSize,
                    borderRadius,
                    borderWidth,
                    spacing,
                    padding,
                    avatarRadius),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(
      BuildContext context,
      String text,
      IconData iconData,
      double iconSize,
      double borderRadius,
      double borderWidth,
      double spacing,
      double padding,
      double avatarRadius) {
    final bool isSelected =
        selectedOption == text; // Check if this option is selected
    final borderColor =
        isSelected ? ColorsManager.primaryColor : Colors.grey.withOpacity(0.3);
    final iconColor = isSelected
        ? ColorsManager.whiteColor
        : ColorsManager.iconColor; // Change icon color based on selection
    final textColor = isSelected ? ColorsManager.primaryColor : Colors.black;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = text;
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: padding),
        margin: EdgeInsets.symmetric(horizontal: spacing),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: CircleAvatar(
                backgroundColor: isSelected
                    ? ColorsManager.secondaryColor
                    : ColorsManager.unSelected,
                radius: avatarRadius,
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Text(
              text,
              style: TextStyle(
                fontSize: 10.sp, // Adjusted for screen width
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            floating: true,
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
          SliverAppBar(
            backgroundColor: ColorsManager.whiteColor,
            elevation: 2,
            toolbarHeight: 2.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  _buildFilterSection(MediaQuery.of(context).size.width),
            ),
          ),
          DisplayProduct(
            selectedOption: selectedOption,
          ),
        ],
      ),
    );
  }
}
