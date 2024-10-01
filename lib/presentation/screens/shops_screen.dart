import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/shop_model.dart';
import 'package:gozip/data/repository/shop_data_repo.dart';
import 'package:gozip/presentation/screens/store_view.dart';
import 'package:gozip/presentation/widgets/shop_screen_widget/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      locality.text = preferences.getString('location') ?? "Belagavi";
    });
  }

  void changePreference(String newLocality) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('location', newLocality);
  }

  final List<String> availableCities = ["Belagavi"];

  TextEditingController locaitonController = TextEditingController();

  TextEditingController locality = TextEditingController();

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
                        locality.text = availableCities[index];
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

  @override
  Widget build(BuildContext context) {
    final ProductStream shopsStream = ProductStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shops"),
        backgroundColor: ColorsManager.primaryColor,
      ),
      body: StreamBuilder<List<Shop>>(
        stream: shopsStream.getNearbyShops(locality.text),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            print("no data");
            return Center(
              child: InkWell(
                onTap: () {},
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
                              'Gozip is not Availbale at\n ${locality.text.trim().toUpperCase()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 12.sp,
                                    color:
                                        const Color.fromARGB(255, 246, 37, 37),
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
                                icon: const Icon(Icons.arrow_drop_down_circle))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          final shops = snapshot.data!;
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: shops.length + 1,
              itemBuilder: (context, index) {
                if (index == shops.length) {
                  return Padding(
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
                              "More Shops Coming Soon...",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final shop = shops[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StoreView(sellerId: shops[index].cid),
                        ));
                  },
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      child: ShopCard(
                        shopLogoPath: shop.shopLogoPath,
                        shopBannerPath: shop.shopBannerPath,
                        address: shop.address,
                        shopName: shop.shopName,
                        openTime: shop.openTime,
                        closeTime: shop.closeTime,
                        location: shop.location,
                        shopId: shop.cid,
                        rating: 4.5, //actual rating logic
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
