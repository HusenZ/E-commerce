import 'package:gozip/bloc/update_user_bloc/update_event_event.dart';
import 'package:gozip/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:gozip/bloc/update_user_bloc/update_user_state.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/core/theme/fonts_manager.dart';
import 'package:gozip/domain/entities/shipping_address.dart';
import 'package:gozip/data/repository/order_repo.dart';
import 'package:gozip/presentation/widgets/common_widgets/delevated_button.dart';
import 'package:gozip/presentation/widgets/common_widgets/loading_button.dart';
import 'package:gozip/presentation/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip/presentation/widgets/common_widgets/snack_bar.dart';
import 'package:gozip/presentation/widgets/common_widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen(
      {super.key,
      this.userPhone,
      this.userId,
      this.userEmail,
      this.userName,
      this.profileImg});

  final String? profileImg;
  final String? userPhone;
  final String? userId;
  final String? userEmail;
  final String? userName;

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserOrderRepository userOrderRepository = UserOrderRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //Shipping controllers
  Shipping? address;
  bool hasAddress = false;

  bool isLoading = false;
  bool profileUpdated = false;

  final GlobalKey<FormState> _setProfileFormKey = GlobalKey<FormState>();
  final GlobalKey<TooltipState> _tooltipkey = GlobalKey<TooltipState>();

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

  Widget returnLabel(String label) {
    return Container(
      padding: EdgeInsets.only(left: 3.w, bottom: 1.w),
      alignment: Alignment.centerLeft,
      child: Text(
        " $label",
        style:
            TextStyle(fontSize: FontSize.s14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName!;
    _emailController.text = widget.userEmail!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final inputTextSize = screenWidth * 0.04;
    return BlocListener<UserUpdateBloc, UserUpdateState>(
      listener: (context, state) {
        if (state is UserUpdateSuccess) {
          Navigator.pop(context);
        }
        if (state is UserUpdateLoading) {}
      },
      child: BlocBuilder<UserUpdateBloc, UserUpdateState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Personal Info"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.h),
                child: Form(
                  key: _setProfileFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          returnLabel("Name"),
                          SizedBox(
                            width: 85.w,
                            height: 8.h,
                            child: DTextformField(
                              readOnly: false,
                              controller: _nameController,
                              hintText: widget.userName,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Full Name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        children: [
                          returnLabel("Email"),
                          SizedBox(
                            width: 85.w,
                            height: 8.h,
                            child: DTextformField(
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              hintText: widget.userEmail,
                              inputTextSize: inputTextSize,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        children: [
                          returnLabel("Phone number"),
                          Container(
                            width: 85.w,
                            height: 8.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 4.w),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorsManager.greyColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              widget.userPhone ?? 'no num',
                              style: const TextStyle(fontSize: FontSize.s18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      //shipping address update
                      Row(
                        children: [
                          returnLabel('Shipping Address'),
                          SizedBox(
                              width:
                                  30.w), // Add spacing between label and icon
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
                      StreamBuilder<Shipping?>(
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

                            print(address);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address!.name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                            'PostalCode: ${address!.postalCode}'),
                                        SizedBox(height: 1.h),
                                        Text('Country: ${address!.country}'),
                                        SizedBox(height: 1.h),
                                        Text('City: ${address!.city}'),
                                        SizedBox(height: 1.h),
                                        Text(
                                            'Street Address: ${address!.street}'),
                                        SizedBox(height: 1.h),
                                        Text('House n.o: ${address!.houseNum}'),
                                        SizedBox(height: 1.h),
                                        Text(
                                            'Phone n.o: ${address!.phoneNumber}'),
                                        TextButton(
                                            onPressed: () {
                                              showShippingAddressBottomSheet(
                                                  context, true);
                                            },
                                            child:
                                                const Text("Update Address")),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Do it Later!",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                      isLoading
                          ? const LoadingButton()
                          : DelevatedButton(
                              text: 'SAVE',
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });

                                print("value is");
                                print(profileUpdated);

                                BlocProvider.of<UserUpdateBloc>(context)
                                    .add(UpdateUserEvent(
                                  userId: widget.userId!,
                                  phone: widget.userPhone!,
                                  name: _nameController.text,
                                  email: widget.userEmail!,
                                ));
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
