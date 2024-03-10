import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _contactEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 17.h,
            ),
            Image.asset(
              "assets/images/dp.png",
              width: 95.h,
              height: 35.h,
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 4.h),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 4.h,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: 88.w,
              height: 10.h,
              child: InputTextField(
                  contactEditingController: _contactEditingController),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.accentColor,
                  foregroundColor: ColorsManager.whiteColor,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 20.sp)),
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/otp',
                  arguments: {
                    'phoneNumber': '+91${_contactEditingController.text}',
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required TextEditingController contactEditingController,
  }) : _contactEditingController = contactEditingController;

  final TextEditingController _contactEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixText: '+91 ',
        prefixStyle: TextStyle(
          fontSize: 3.h,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        hintText: 'Enter your phone number',
        hintStyle: TextStyle(
          fontSize: 3.h,
          color: Colors.grey[400],
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsManager.primaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _contactEditingController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      style: TextStyle(fontSize: 3.h),
    );
  }
}
