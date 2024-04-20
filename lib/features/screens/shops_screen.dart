import 'package:daprot_v1/bloc/location_bloc/user_locaion_events.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_bloc.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_state.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/domain/model/shop_model.dart';
import 'package:daprot_v1/domain/shop_data_repo.dart';
import 'package:daprot_v1/features/screens/store_view.dart';
import 'package:daprot_v1/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_v1/features/widgets/shop_screen_widget/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  void initState() {
    BlocProvider.of<LocationBloc>(context).add(GetLocationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProductStream shopsStream = ProductStream();
    String locality = '';
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoadingState) {
          locality = 'Loading...';
          LoadingDialog.showLoadingDialog(context);
        }
        if (state is LocationLoadedState) {
          locality = state.placeName!.locality ?? "Belgaum";
          Navigator.of(context).pop();
          debugPrint(locality);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Daprot Shops"),
            backgroundColor: ColorsManager.primaryColor,
          ),
          body: StreamBuilder<List<Shop>>(
            stream: shopsStream.getNearbyShops(locality),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Text("no shops available");
              }
              final shops = snapshot.data!;
              return ListView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
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
                    child: ShopCard(
                      shopLogoPath: shop.shopLogoPath,
                      shopBannerPath: shop.shopBannerPath,
                      shopName: shop.shopName,
                      openTime: shop.openTime,
                      closeTime: shop.closeTime,
                      location: shop.location,
                      rating: 4.5, //actual rating logic
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
