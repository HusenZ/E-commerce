import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/config/theme/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.location});
  final String location;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<QueryDocumentSnapshot<Object?>> searchedProducts = [];
  List<QueryDocumentSnapshot<Object?>> searchedShops = [];

  // Replace with your actual Firestore references
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference _shopsCollection = FirebaseFirestore.instance
      .collection(
          'Shops'); // Assuming shop location is stored within the Shops collection
  // OR
  // final CollectionReference _locationsCollection = FirebaseFirestore.instance.collection('Locations'); // For separate location collection approach

  void _performSearch(String text) async {
    if (text.isEmpty) return; // Handle empty search
    print(text);

    // Combine searches for products and shops
    final productResults = await _productsCollection
        .where('name', isGreaterThanOrEqualTo: text)
        .get();

    final shopResults = await _shopsCollection
        .where('name', isGreaterThanOrEqualTo: text)
        .get();

    // Display combined search results (use productResults.docs and shopResults.docs to access documents)
    if (productResults.docs.isNotEmpty) Text('Products');
    if (productResults.docs.isNotEmpty) {
      print(productResults.docs.first['name']);
      for (final doc in productResults.docs) {
        setState(() {
          searchedProducts.add(doc);
        });
      }
    }
    if (shopResults.docs.isNotEmpty) Text('Shops');
    if (shopResults.docs.isNotEmpty) {
      print(shopResults.docs.first['name']);
      for (final doc in shopResults.docs) {
        setState(() {
          searchedShops.add(doc);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorsManager.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                margin: EdgeInsets.symmetric(vertical: 2.h),
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(
                      color: ColorsManager.blackColor,
                      fontWeight: FontWeightManager.semiBold),
                  onChanged: (text) {
                    _performSearch(text);
                  },
                  cursorColor: ColorsManager.primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ColorsManager.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ColorsManager.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(2.w),
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
            ],
          ),
        ),
      ),
    );
  }
}
