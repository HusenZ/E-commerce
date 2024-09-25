import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/core/theme/fonts_manager.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/presentation/screens/product_details_screen.dart';
import 'package:gozip/presentation/screens/store_view.dart';
import 'package:gozip/presentation/widgets/product_s_widget/row_procuts.dart';
import 'package:gozip/presentation/widgets/shop_screen_widget/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, required this.location});
  String location;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  List<QueryDocumentSnapshot<Object?>> searchedProducts = [];
  List<QueryDocumentSnapshot<Object?>> searchedShops = [];

  // Replace with your actual Firestore references
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference _shopsCollection =
      FirebaseFirestore.instance.collection('Shops');
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocation();
    _tabController = TabController(length: 2, vsync: this);
  }

  void getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      widget.location = preferences.getString('location') ?? "Belagavi";
    });
  }

  List<String> tokenize(String text) {
    final pattern = RegExp(r'\w+');
    return text.toLowerCase().split(pattern);
  }

  bool isProductRelevant(String searchText, String productName) {
    final searchTokens = tokenize(searchText);
    final productTokens = tokenize(productName);
    return searchTokens.any((token) => productTokens.contains(token));
  }

  bool isExactMatch(String searchText, String name) {
    return searchText.toLowerCase() == name.toLowerCase();
  }

  bool isShopRelevant(String searchText, dynamic shopData) {
    if (shopData == null) return false;

    final shopName = shopData.toString().toLowerCase();

    final searchTokens = tokenize(searchText);
    final shopNameTokens = tokenize(shopName);

    return searchTokens.any((token) => shopNameTokens.contains(token));
  }

  void _performSearch(String text) async {
    if (text.isEmpty) {
      setState(() {
        searchedProducts.clear();
        searchedShops.clear();
      });
      return;
    }

    final lowerCaseText = text.toLowerCase();
    final productResults = await _productsCollection.get();
    final shopResults = await _shopsCollection.get();

    setState(() {
      searchedProducts = productResults.docs
          .where((doc) => doc['location'] == widget.location.trim())
          .where((doc) => isProductRelevant(lowerCaseText, doc['name']))
          .toList()
        ..sort((a, b) => isExactMatch(lowerCaseText, a['name']) ? -1 : 1);
      searchedShops = shopResults.docs
          .where((doc) => doc['address'] == widget.location.trim())
          .where((doc) => isShopRelevant(lowerCaseText, doc['name']))
          .where((element) => element['applicationStatus'] == "verified")
          .toList()
        ..sort((a, b) => isExactMatch(lowerCaseText, a['name']) ? -1 : 1);
    });
    _sortResults(lowerCaseText);
  }

  void _sortResults(String lowerCaseText) {
    searchedProducts.sort((a, b) {
      final relevanceA = _calculateRelevance(lowerCaseText, a['name']);
      final relevanceB = _calculateRelevance(lowerCaseText, b['name']);
      return relevanceB.compareTo(relevanceA);
    });
    searchedShops.sort((a, b) {
      final relevanceA = _calculateRelevance(lowerCaseText, a['name']);
      final relevanceB = _calculateRelevance(lowerCaseText, b['name']);
      return relevanceB.compareTo(relevanceA);
    });
  }

  int _calculateRelevance(String searchText, String name) {
    if (isExactMatch(searchText, name)) {
      return 2;
    } else if (name.toLowerCase().startsWith(searchText)) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(15.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Container(
            height: 6.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorsManager.accentColor,
              ),
              borderRadius: BorderRadius.circular(5.w),
            ),
            margin: EdgeInsets.symmetric(vertical: 1.h),
            child: TextField(
              autofocus: true,
              controller: _searchController,
              style: TextStyle(
                  color: ColorsManager.blackColor,
                  fontWeight: FontWeightManager.normal,
                  fontSize: 14.sp),
              onChanged: (text) {
                _performSearch(text);
              },
              cursorColor: ColorsManager.primaryColor,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: ColorsManager.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: ColorsManager.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                prefixIcon: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: ColorsManager.blackColor,
                  ),
                ),
                border: InputBorder.none,
                hintText: 'Search Here',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: ColorsManager.greyColor,
                ),
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Products'),
              Tab(text: 'Shops'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(),
          _buildShopsTab(),
        ],
      ),
    );
  }

  Widget _buildShopsTab() {
    if (searchedProducts.isEmpty) {
      return const Center(child: Text("No Shops Available, Search for It"));
    }
    return ListView.builder(
      itemCount: searchedShops.length,
      itemBuilder: (context, index) {
        final shop = searchedShops[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreView(sellerId: shop['cid']),
                ));
          },
          child: ShopCard(
            shopLogoPath: shop['shopLogo'],
            address: shop['address'],
            shopBannerPath: shop['shopImage'],
            shopName: shop['name'],
            openTime: shop['openTime'],
            closeTime: shop['closeTime'],
            location: shop['location'],
            shopId: shop['cid'],
            rating: 4.5,
          ),
        );
      },
    );
  }

  Widget _buildProductsTab() {
    if (searchedProducts.isEmpty) {
      return const Center(child: Text("No Products Available, Search for It"));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0.5.w,
        mainAxisSpacing: 0.5.h,
      ),
      itemCount: searchedProducts.length,
      itemBuilder: (context, index) {
        final product = searchedProducts[index];

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
                      category: mapCategory[product['category']],
                      shopId: product['shopId'],
                      productId: product['productId'],
                      discountedPrice: product['discountedPrice'],
                    ),
                  ),
                ));
          },
          title: product['name'],
          price: product['price'],
          image: product['selectedPhotos'].first,
        );
      },
    );
  }
}
