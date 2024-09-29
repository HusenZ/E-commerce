import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/core/constants/app_icons.dart';
import 'package:gozip/core/constants/lottie_img.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/domain/entities/category.dart';
import 'package:gozip/domain/repository/connectivity_helper.dart';
import 'package:gozip/presentation/screens/product_details_screen.dart';
import 'package:gozip/presentation/screens/search_screen.dart';
import 'package:gozip/presentation/widgets/home_widgets/home_product_card.dart';
import 'package:gozip/presentation/widgets/home_widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.locality});
  final TextEditingController locality;

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  String selectedOption = 'all';
  String selectedSubCat = 'all';
  final List<String> availableCities = ["Belagavi"];

  void changePreference(String newLocality) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('location', newLocality);
  }

  Widget _buildFilterOption(
      BuildContext context,
      String text,
      IconData? iconData,
      double iconSize,
      double borderRadius,
      double borderWidth,
      double spacing,
      double padding,
      double avatarRadius,
      String? iconImage) {
    final bool isSelected =
        selectedOption == text; // Check if this option is selected
    final borderColor =
        isSelected ? ColorsManager.primaryColor : Colors.grey.withOpacity(0.3);
    final iconColor = isSelected
        ? ColorsManager.whiteColor
        : ColorsManager.iconColor; // Change icon color based on selection
    final textColor = isSelected ? ColorsManager.secondaryColor : Colors.black;

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
                child: iconData == null
                    ? ImageIcon(AssetImage(iconImage!))
                    : Icon(
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

  Widget _buildFilterSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalMargin = screenWidth * 0.01;
    double verticalMargin = 0.001.w;
    double iconSize = screenWidth * 0.030;
    double borderRadius = screenWidth * 0.04;
    double borderWidth = screenWidth * 0.0025;
    double spacing = screenWidth * 0.02;
    double padding = screenWidth * 0.015;
    double avatarRadius = screenWidth * 0.034;

    return Container(
      width: double.infinity,
      height: 5.h,
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 375),
              child: FlipAnimation(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterOption(
                        context,
                        'All',
                        Icons.all_inclusive_rounded,
                        iconSize,
                        borderRadius,
                        borderWidth,
                        spacing,
                        padding,
                        avatarRadius,
                        null),
                    _buildFilterOption(
                        context,
                        Category.men.name.toUpperCase(),
                        null,
                        iconSize,
                        borderRadius,
                        borderWidth,
                        spacing,
                        padding,
                        avatarRadius,
                        AppIcons.men),
                    _buildFilterOption(
                        context,
                        Category.women.name.toUpperCase(),
                        null,
                        iconSize,
                        borderRadius,
                        borderWidth,
                        spacing,
                        padding,
                        avatarRadius,
                        AppIcons.women),
                    _buildFilterOption(
                        context,
                        'ElectronicsAndGadgets'.toUpperCase(),
                        Icons.electrical_services_sharp,
                        iconSize,
                        borderRadius,
                        borderWidth,
                        spacing,
                        padding,
                        avatarRadius,
                        null),
                    _buildFilterOption(
                        context,
                        Category.accessories.name.toUpperCase(),
                        null,
                        iconSize,
                        borderRadius,
                        borderWidth,
                        spacing,
                        padding,
                        avatarRadius,
                        AppIcons.accessories),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String trimmedLocality = widget.locality.text.trim();
    if (trimmedLocality == 'Belgaum' ||
        trimmedLocality == 'Belgaum(Belagavi)' ||
        trimmedLocality == 'Belagavi(Belgaum)') {
      trimmedLocality = 'Belagavi';
    }
    Query query = FirebaseFirestore.instance
        .collection('Products')
        .where('location', isEqualTo: trimmedLocality)
        .orderBy('clicks', descending: true);

    // If the selectedOption is not 'all', add a filter for the category

    return StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data == null) {
            return const Scaffold(
                body: Center(child: Text("no prodcuts available")));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      updateLocationSheet(context);
                    },
                    child: Container(
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.sp),
                        gradient: const LinearGradient(
                          colors: [
                            ColorsManager.primaryColor,
                            ColorsManager.secondaryColor,
                            ColorsManager.backgroundColor
                          ],
                        ),
                        border: Border.all(color: Colors.teal.shade100),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Gozip is not Availbale at\n ${widget.locality.text.trim().toUpperCase()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontSize: 12.sp,
                                        color: const Color.fromARGB(
                                            255, 246, 37, 37),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Explore Other Cities ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                ),
                                IconButton.filled(
                                    onPressed: () {
                                      updateLocationSheet(context);
                                    },
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Text('Try app later'), //TODO: Update this later
            );
          }

          // Filter products based on the selected category
          List<DocumentSnapshot> filteredProducts;
          if (selectedOption.toLowerCase() == 'all') {
            filteredProducts = snapshot.data!.docs;
          } else {
            filteredProducts = snapshot.data!.docs
                .where((doc) =>
                    doc['category'].toString().toLowerCase() ==
                    selectedOption.toLowerCase())
                .toList();
          }

          return AnimationLimiter(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  expandedHeight: 20.h,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    //background
                    background: AnimationConfiguration.synchronized(
                      child: FlipAnimation(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8.sp, left: 8.sp),
                                child: const WishBarWidgets(),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                        location: widget.locality.text),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: TextField(
                                      readOnly: true,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.sp),
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Color.fromARGB(
                                              255, 151, 147, 147),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.all(1.w),
                                            decoration: BoxDecoration(
                                              color: ColorsManager.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: const Icon(
                                              Icons.filter_list,
                                              color: Color.fromARGB(
                                                  255, 19, 25, 61),
                                            ),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(1.w),
                                        border: InputBorder.none,
                                        hintText: "Search Here",
                                        hintStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color.fromARGB(
                                              255, 151, 147, 147),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    title: InkWell(
                      onTap: () {
                        updateLocationSheet(context); //TODO: add that function
                      },
                      child: AnimationConfiguration.synchronized(
                        child: FlipAnimation(
                          child: Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              gradient: const LinearGradient(
                                colors: [
                                  ColorsManager.primaryColor,
                                  ColorsManager.secondaryColor,
                                  ColorsManager.backgroundColor
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 241, 237, 237),
                                ),
                                Text(
                                  'Your are at ${widget.locality.text.trim().toUpperCase()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 12.sp,
                                          color: ColorsManager.whiteColor),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_circle_sharp,
                                  color: ColorsManager.offWhiteColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    titlePadding: const EdgeInsets.all(8.0),
                  ),
                  centerTitle: true,
                ),
                // Row of categories.
                SliverAppBar(
                  backgroundColor: ColorsManager.whiteColor,
                  elevation: 2,
                  toolbarHeight: 2.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildFilterSection(),
                  ),
                ),
                if (filteredProducts.isEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Lottie.asset(
                          AppLottie.commingSoon,
                          repeat: false,
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(9.sp),
                            child: RichText(
                              softWrap: true,
                              text: TextSpan(
                                text:
                                    "No products available for the selected category.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 13.sp,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (filteredProducts.isNotEmpty)
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of grid columns
                      crossAxisSpacing: 1.0, // Spacing between grid items
                      mainAxisSpacing: 6.sp, // Spacing between grid rows
                      childAspectRatio:
                          0.6.sp, // Aspect ratio of grid items (width / height)
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: SlideAnimation(
                            child: HomeProductCard(
                              product: Product(
                                name: filteredProducts[index]['name'],
                                price: filteredProducts[index]['price'],
                                details: filteredProducts[index]['description'],
                                imageUrl: filteredProducts[index]
                                    ['selectedPhotos'],
                                shopId: filteredProducts[index]['shopId'],
                                category: mapCategory[filteredProducts[index]
                                    ['category']],
                                productId: filteredProducts[index]['productId'],
                                discountedPrice: filteredProducts[index]
                                    ['discountedPrice'],
                              ),
                              onTap: () async {
                                ConnectivityHelper.navigateRoute(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      product: Product(
                                        name: filteredProducts[index]['name'],
                                        price: filteredProducts[index]['price'],
                                        details: filteredProducts[index]
                                            ['description'],
                                        imageUrl: filteredProducts[index]
                                            ['selectedPhotos'],
                                        shopId: filteredProducts[index]
                                            ['shopId'],
                                        category: mapCategory[
                                            filteredProducts[index]
                                                ['category']],
                                        productId: filteredProducts[index]
                                            ['productId'],
                                        discountedPrice: filteredProducts[index]
                                            ['discountedPrice'],
                                      ),
                                    ),
                                  ),
                                );

                                await snapshot.data!.docs[index].reference
                                    .update({
                                  'clicks': FieldValue.increment(1),
                                });
                              },
                              height: 40.h,
                              width: 2.h,
                            ),
                          ),
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Card(
                      elevation: 0.0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 18.sp),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_filled),
                            SizedBox(
                              width: 12.sp,
                            ),
                            Text(
                              "More Products Coming Soon...",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> updateLocationSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'District/city',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.sp),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.sp),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: availableCities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      availableCities[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      setState(() {
                        widget.locality.text = availableCities[index];
                        changePreference(availableCities[index]);
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
