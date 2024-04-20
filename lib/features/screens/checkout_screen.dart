import 'package:cached_network_image/cached_network_image.dart';
import 'package:daprot_v1/bloc/location_bloc/user_locaion_events.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_bloc.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_state.dart';
import 'package:daprot_v1/config/routes/routes_manager.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/domain/connectivity_helper.dart';
import 'package:daprot_v1/domain/model/order_models.dart';
import 'package:daprot_v1/domain/model/shipping_address.dart';
import 'package:daprot_v1/domain/order_repo.dart';
import 'package:daprot_v1/features/widgets/common_widgets/delevated_button.dart';
import 'package:daprot_v1/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_v1/features/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    UserOrderRepository userOrderRepository = UserOrderRepository();
    String? imageUrl;
    String? title;
    int? quantity;
    String? price;
    OrderModel? orderModelPush;
    bool hasAddress = false;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController houseNumController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController postalCodeController = TextEditingController();
    final TextEditingController countryController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      imageUrl = args['imageUrl'] ?? '';
      title = args['title'] ?? '';
      quantity = args['quantity'] ?? 0;
      price = args['price'] ?? '';
      orderModelPush = args['orderModel'] ?? "";
    }

    void confirmPurchase({required OrderModel orderModel}) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Purchase'),
            content: const Text('Are you sure you want to purchase this item?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  LoadingDialog.showOrderLoading(context);
                  await userOrderRepository.placeOrder(orderModel).then(
                    (value) {
                      BlocProvider.of<LocationBloc>(context)
                          .add(GetLocationEvent());
                      Navigator.pop(context);
                      ConnectivityHelper.replaceIfConnected(
                          context, Routes.ordersRoute);
                      customSnackBar(context, "Successfully placed", true);
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Buy',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          );
        },
      );
    }

    void showShippingAddressBottomSheet(BuildContext context) {
      showModalBottomSheet<Shipping>(
        context: context,
        isScrollControlled: true,
        builder: (context) => _ShippingAddressForm(
            nameController: nameController,
            houseNumController: houseNumController,
            streetController: streetController,
            cityController: cityController,
            stateController: stateController,
            postalCodeController: postalCodeController,
            countryController: countryController,
            phoneNumberController: phoneNumberController),
      ).then((shippingAddress) {
        if (shippingAddress != null) {
          // Process the entered shipping address (e.g., save to backend)
          print(
              "Shipping Address: ${shippingAddress.name}, ${shippingAddress.country}");
          // Update UI to display the new address (optional)
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Checkout",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.all(16.sp),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.sp),
                      child: SizedBox(
                        height: 12.h,
                        width: 12.h,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? "Product Name",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 16.sp,
                                    color: ColorsManager.blackColor),
                          ),
                          const SizedBox(height: 4.0),
                          Text("Quantity: ${quantity ?? 0}"),
                          const SizedBox(height: 4.0),
                          Text("Total Price: ₹ ${price ?? "0"}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15.sp),
              child: Text(
                "Shipping address",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 12.sp),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<Shipping?>(
              stream: userOrderRepository.getShippingAddress(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  hasAddress = false;

                  return DelevatedButton(
                    onTap: () {
                      showShippingAddressBottomSheet(context);
                    },
                    text: "Add Address",
                  );
                }
                if (snapshot.hasData) {
                  Shipping address = snapshot.data!;

                  hasAddress = true;

                  print(address);
                  return Card(
                    margin: EdgeInsets.only(
                        top: 5.sp, bottom: 15.sp, left: 16.sp, right: 16.sp),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text('Street: ${address.postalCode}'),
                          SizedBox(height: 1.h),
                          Text('Country: ${address.country}'),
                          SizedBox(height: 1.h),
                          Text('City: ${address.city}'),
                          SizedBox(height: 1.h),
                          Text('Street Address: ${address.street}'),
                          SizedBox(height: 1.h),
                          Text('House n.o: ${address.houseNum}'),
                          SizedBox(height: 1.h),
                          Text('Phone n.o: ${address.phoneNumber}'),
                          TextButton(
                              onPressed: () {
                                showShippingAddressBottomSheet(context);
                              },
                              child: const Text("Update Address")),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: DelevatedButton(
              onTap: () async {
                confirmPurchase(
                    orderModel: OrderModel(
                        orderId: orderModelPush!.orderId,
                        userId: orderModelPush.userId,
                        orderItems: [
                          OrderItem(
                              name: orderModelPush.orderItems.first.name,
                              discountedPrice: orderModelPush
                                  .orderItems.first.discountedPrice,
                              price: orderModelPush.orderItems.first.price,
                              details: orderModelPush.orderItems.first.details,
                              imageUrl:
                                  orderModelPush.orderItems.first.imageUrl,
                              category:
                                  orderModelPush.orderItems.first.category,
                              shopId: orderModelPush.orderItems.first.shopId,
                              productId:
                                  orderModelPush.orderItems.first.productId)
                        ],
                        totalPrice: price!,
                        orderStatus: orderModelPush.orderStatus,
                        orderDate: orderModelPush.orderDate,
                        shopId: orderModelPush.shopId,
                        quantity: quantity.toString(),
                        productId: orderModelPush.productId));
              },
              text: "BUY NOW",
            ),
          )
        ],
      ),
    );
  }
}

class _ShippingAddressForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController houseNumController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final TextEditingController countryController;
  final TextEditingController phoneNumberController;

  const _ShippingAddressForm({
    required this.nameController,
    required this.houseNumController,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.countryController,
    required this.phoneNumberController,
  });
  @override
  State<_ShippingAddressForm> createState() => _ShippingAddressFormState();
}

class _ShippingAddressFormState extends State<_ShippingAddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget.nameController.dispose();
    widget.houseNumController.dispose();
    widget.streetController.dispose();
    widget.cityController.dispose();
    widget.stateController.dispose();
    widget.postalCodeController.dispose();
    widget.countryController.dispose();
    widget.phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationLoadingState) {}
        if (state is LocationLoadedState) {
          widget.cityController.text = state.placeName!.locality!;
          widget.postalCodeController.text = state.placeName!.postalCode!;
          widget.countryController.text = state.placeName!.country!;
          widget.streetController.text = state.placeName!.street!;
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(8.sp),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Set minimum height for the sheet
                children: [
                  Text(
                    "Enter Shipping Address",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  DelevatedButton(
                      text: 'Current Location',
                      onTap: () => BlocProvider.of<LocationBloc>(context)
                          .add(GetLocationEvent())),
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: widget.nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12.sp),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: widget.houseNumController,
                          decoration: InputDecoration(
                            labelText: "House Number",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 12.sp),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter house number";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: TextFormField(
                          controller: widget.streetController,
                          decoration: InputDecoration(
                            labelText: "Street",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 12.sp),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter street name";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: widget.cityController,
                    decoration: InputDecoration(
                      labelText: "City",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12.sp),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter city name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: widget.stateController,
                    decoration: InputDecoration(
                      labelText: "State (Optional)",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12.sp),
                    ),
                  ),
                  TextFormField(
                    controller: widget.postalCodeController,
                    decoration: InputDecoration(
                      labelText: "Postal Code",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12.sp),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter postal code";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: widget.countryController,
                    decoration: InputDecoration(
                      labelText: "Country",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12.sp),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter country name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: widget.phoneNumberController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12.sp),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter phone number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Create ShippingAddress object
                            Shipping address = Shipping(
                              name: widget.nameController.text,
                              houseNum: widget.houseNumController.text,
                              street: widget.stateController.text,
                              city: widget.cityController.text,
                              state: widget.stateController.text,
                              postalCode: widget.postalCodeController.text,
                              country: widget.countryController.text,
                              phoneNumber: widget.phoneNumberController.text,
                            );
                            UserOrderRepository()
                                .putShippingAddress(address)
                                .then(
                              (value) {
                                customSnackBar(context, 'Address Stored', true);
                                Navigator.pop(context,
                                    address); // Return ShippingAddress data
                              },
                            );
                          }
                        },
                        child: const Text("Save Address"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
