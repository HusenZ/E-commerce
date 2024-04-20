import 'package:daprot_v1/bloc/location_bloc/user_locaion_events.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_bloc.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_state.dart';
import 'package:daprot_v1/config/constants/app_icons.dart';
import 'package:daprot_v1/config/constants/app_images.dart';
import 'package:daprot_v1/config/constants/city_const.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:daprot_v1/domain/connectivity_helper.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/cart_screen.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:daprot_v1/features/screens/profile_screen.dart';
import 'package:daprot_v1/features/screens/search_screen.dart';
import 'package:daprot_v1/features/screens/shops_screen.dart';
import 'package:daprot_v1/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_v1/features/widgets/home_widgets/location_widget.dart';
import 'package:daprot_v1/features/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedOption = "All";
  int _selectedIndex = 0;
  bool isConnected = false;
  ProductStream repo = ProductStream();
  TextEditingController locaitonController = TextEditingController();
  TextEditingController locality = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkConnecivity();
    BlocProvider.of<LocationBloc>(context).add(GetLocationEvent());
  }

  void checkConnecivity() async {
    isConnected = await ConnectivityHelper.checkConnection();
  }

  /*Home section */
  Widget displayHomeScreen(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoadingState) {
          LoadingDialog.showLoadingDialog(context);
        }
        if (state is LocationLoadedState) {
          locaitonController.text = state.placeName!.street ?? " null ";
          setState(() {
            locality.text = state.placeName!.locality ?? "Belgaum";
          });
          Navigator.pop(context);
          debugPrint(locality.text);
        }
      },
      builder: (context, state) {
        return CustomScrollView(
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
                background: Container(
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
                            builder: (context) =>
                                SearchScreen(location: locality.text),
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
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.sp),
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color.fromARGB(255, 151, 147, 147),
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
                                      color: Color.fromARGB(255, 19, 25, 61),
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(1.w),
                                border: InputBorder.none,
                                hintText: "Search Here",
                                hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color:
                                      const Color.fromARGB(255, 151, 147, 147),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Column(
                          children: [
                            TextField(
                              controller: locaitonController,
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
                                itemCount: suggestedLocations.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      suggestedLocations[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        locaitonController.text =
                                            suggestedLocations[index];
                                        locality.text =
                                            suggestedLocations[index];
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
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 184, 233, 238),
                    shape: Border.all(
                        style: BorderStyle.solid, color: Colors.white),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on),
                        Text(
                          'Your are at ${locaitonController.text.trim().toUpperCase()}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 12.sp),
                        ),
                        const Icon(Icons.arrow_drop_down_circle_sharp)
                      ],
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
            StreamBuilder(
                stream: repo.getProductsForShopsStream(locality.text.trim()),
                builder: (context, snapshot) {
                  final product = snapshot.data;
                  if (product == null) {
                    return const SliverToBoxAdapter(
                        child: Text("no prodcuts available"));
                  }
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of grid columns
                      crossAxisSpacing: 10, // Spacing between grid items
                      mainAxisSpacing: 10, // Spacing between grid rows
                      childAspectRatio:
                          0.7, // Aspect ratio of grid items (width / height)
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return HomeProductCard(
                          product: Product(
                            name: product.docs[index]['name'],
                            price: product.docs[index]['price'],
                            details: product.docs[index]['description'],
                            imageUrl: product.docs[index]['selectedPhotos'],
                            shopId: product.docs[index]['shopId'],
                            category:
                                mapCategory[product.docs[index]['category']],
                            productId: product.docs[index]['productId'],
                            discountedPrice: product.docs[index]
                                ['discountedPrice'],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  product: Product(
                                    name: product.docs[index]['name'],
                                    price: product.docs[index]['price'],
                                    details: product.docs[index]['description'],
                                    imageUrl: product.docs[index]
                                        ['selectedPhotos'],
                                    shopId: product.docs[index]['shopId'],
                                    category: mapCategory[product.docs[index]
                                        ['category']],
                                    productId: product.docs[index]['productId'],
                                    discountedPrice: product.docs[index]
                                        ['discountedPrice'],
                                  ),
                                ),
                              ),
                            );
                          },
                          height: 30.h,
                          width: 2.h,
                        );
                      },
                      childCount: product.docs.length,
                    ),
                  );
                }),
          ],
        );
      },
    );
  }

  final List _pages = [
    const HomeScreen(),
    const ShopsScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  // Handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? displayHomeScreen(context)
          : _pages[_selectedIndex],
      /*BOTTOM NAVIGATION BAR */
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppIcons.home),
              color: Color.fromARGB(255, 14, 112, 241),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppIcons.shops),
              color: Color.fromARGB(255, 14, 112, 241),
            ),
            label: 'Shops',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppImages.cartLogo),
              color: Color.fromARGB(255, 14, 112, 241),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppImages.profileLogo),
              color: Color.fromARGB(255, 14, 112, 241),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: const Color.fromARGB(
            255, 14, 112, 241), // Customize selected item color
        onTap: _onItemTapped, // Handle item tap
      ),
    );
  }
}
