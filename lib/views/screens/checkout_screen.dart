import 'package:cached_network_image/cached_network_image.dart';
import 'package:gozip/config/routes/routes_manager.dart';
import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/utils/connectivity_helper.dart';
import 'package:gozip/model/order_models.dart';
import 'package:gozip/model/shipping_address.dart';
import 'package:gozip/utils/order_repo.dart';
import 'package:gozip/views/widgets/common_widgets/delevated_button.dart';
import 'package:gozip/views/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip/views/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    Shipping? address;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController houseNumController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

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
            content: RichText(
                text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 14.sp),
              text:
                  "Important: Gozip connects you directly with local sellers. Seller will contact you shortly to finalize your order and discuss payment & delivery options. Please note that Gozip is not responsible for payment processing, returns, or replacements. Be sure to discuss these details directly with the seller.",
            )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.red, fontSize: 14.sp),
                ),
              ),
              TextButton(
                onPressed: () async {
                  LoadingDialog.showOrderLoading(context);
                  await userOrderRepository.placeOrder(orderModel).then(
                    (value) {
                      Navigator.pop(context);
                      ConnectivityHelper.clareStackPush(
                          context, Routes.ordersRoute);
                      customSnackBar(context, "Successfully placed", true);
                    },
                  );
                },
                child: Text(
                  'Buy Now',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.green, fontSize: 14.sp),
                ),
              ),
            ],
          );
        },
      );
    }

    void showShippingAddressBottomSheet(BuildContext context, bool isupdate) {
      showModalBottomSheet<Shipping>(
        context: context,
        isScrollControlled: true,
        builder: (context) => _ShippingAddressForm(
          address: address ??
              Shipping(
                  name: '',
                  houseNum: '',
                  street: '',
                  city: '',
                  state: '',
                  postalCode: '',
                  country: '',
                  phoneNumber: ''),
          isUpdate: isupdate,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
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
                      width: 1.h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60.w,
                            child: Text(
                              title ?? "Product Name",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 13.sp,
                                      color: ColorsManager.blackColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
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
              child: Row(
                children: [
                  Text(
                    "Shipping address",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 12.sp),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      final dynamic tooltip = tooltipkey.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      message:
                          "This address will be used for delivery and shared with the seller.",
                      showDuration: const Duration(seconds: 3),
                      padding: EdgeInsets.all(8.sp),
                      triggerMode: TooltipTriggerMode.manual,
                      preferBelow: true,
                      key: tooltipkey,
                      verticalOffset: 48,
                      child: const Icon(Icons.info),
                    ),
                  ),
                ],
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
                      showShippingAddressBottomSheet(context, false);
                    },
                    text: "Add Address",
                  );
                }
                if (snapshot.hasData) {
                  address = snapshot.data!;

                  hasAddress = true;
                  nameController.text = address!.name;
                  houseNumController.text = address!.houseNum;
                  phoneNumberController.text = address!.phoneNumber;
                  nameController.text = address!.name;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        margin: EdgeInsets.only(
                            top: 5.sp,
                            bottom: 15.sp,
                            left: 16.sp,
                            right: 16.sp),
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
                                address!.name,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text('PostalCode: ${address!.postalCode}'),
                              SizedBox(height: 1.h),
                              Text('Country: ${address!.country}'),
                              SizedBox(height: 1.h),
                              Text('City: ${address!.city}'),
                              SizedBox(height: 1.h),
                              Text('Street Address: ${address!.street}'),
                              SizedBox(height: 1.h),
                              Text('House n.o: ${address!.houseNum}'),
                              SizedBox(height: 1.h),
                              Text('Phone n.o: ${address!.phoneNumber}'),
                              TextButton(
                                  onPressed: () {
                                    showShippingAddressBottomSheet(
                                        context, true);
                                  },
                                  child: const Text("Update Address")),
                            ],
                          ),
                        ),
                      ),
                      DelevatedButton(
                        onTap: () async {
                          confirmPurchase(
                              orderModel: OrderModel(
                                  orderId: orderModelPush!.orderId,
                                  userId: orderModelPush.userId,
                                  orderItems: [
                                    OrderItem(
                                        name: orderModelPush
                                            .orderItems.first.name,
                                        discountedPrice: orderModelPush
                                            .orderItems.first.discountedPrice,
                                        price: orderModelPush
                                            .orderItems.first.price,
                                        details: orderModelPush
                                            .orderItems.first.details,
                                        imageUrl: orderModelPush
                                            .orderItems.first.imageUrl,
                                        category: orderModelPush
                                            .orderItems.first.category,
                                        shopId: orderModelPush
                                            .orderItems.first.shopId,
                                        productId: orderModelPush
                                            .orderItems.first.productId)
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
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          // SliverToBoxAdapter(
          //   child:
          // )
        ],
      ),
    );
  }
}

class _ShippingAddressForm extends StatefulWidget {
  final Shipping address;
  final bool isUpdate;
  const _ShippingAddressForm({required this.address, required this.isUpdate});
  @override
  State<_ShippingAddressForm> createState() => _ShippingAddressFormState();
}

class _ShippingAddressFormState extends State<_ShippingAddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<TooltipState> _tooltipkey = GlobalKey<TooltipState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController houseNumController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.address.name;
    houseNumController.text = widget.address.houseNum;
    streetController.text = widget.address.street;
    cityController.text = widget.address.city;
    postalCodeController.text = widget.address.postalCode;
    phoneNumberController.text = widget.address.phoneNumber;
    stateController.text = 'Karnataka';
    countryController.text = 'India';
    getcityname();
    super.initState();
  }

  void getcityname() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    cityController.text =
        preference.getString('location') ?? "Belagavi(Belgaum)";
  }

  @override
  void dispose() {
    nameController.dispose();
    houseNumController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 218, 40, 40),
      statusBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.sp),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      ' Shipping Address',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        final dynamic tooltip = _tooltipkey.currentState;
                        tooltip.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        message:
                            "This address will be used for delivery and shared with the seller.",
                        showDuration: const Duration(seconds: 3),
                        padding: EdgeInsets.all(8.sp),
                        triggerMode: TooltipTriggerMode.manual,
                        preferBelow: true,
                        key: _tooltipkey,
                        verticalOffset: 48,
                        child: const Icon(Icons.info),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: nameController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.blackColor),
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
                        controller: houseNumController,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.blackColor),
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
                        controller: streetController,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.blackColor),
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
                  controller: cityController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.blackColor),
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
                  controller: stateController,
                  readOnly: true,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.blackColor),
                  decoration: InputDecoration(
                    labelText: "State",
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 12.sp),
                  ),
                ),
                TextFormField(
                  controller: postalCodeController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.blackColor),
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
                  controller: countryController,
                  readOnly: true,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.blackColor),
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
                  controller: phoneNumberController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.blackColor),
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
                          LoadingDialog.showLoaderDialog(context);
                          Shipping address = Shipping(
                            name: nameController.text,
                            houseNum: houseNumController.text,
                            street: streetController.text,
                            city: cityController.text,
                            state: stateController.text,
                            postalCode: postalCodeController.text,
                            country: countryController.text,
                            phoneNumber: phoneNumberController.text,
                          );
                          widget.isUpdate
                              ? UserOrderRepository()
                                  .updateShippingAddress(address)
                                  .then(
                                  (value) {
                                    customSnackBar(
                                        context, 'Address Stored', true);
                                    Navigator.pop(
                                      context,
                                    );
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                )
                              : UserOrderRepository()
                                  .putShippingAddress(address)
                                  .then(
                                  (value) {
                                    customSnackBar(
                                        context, 'Address Stored', true);
                                    Navigator.pop(
                                      context,
                                    );
                                    Navigator.pop(
                                      context,
                                    );
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
      ),
    );
  }
}
