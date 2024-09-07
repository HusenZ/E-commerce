import 'package:gozip/polycies/privacy_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 218, 40, 40),
      statusBarIconBrightness: Brightness.light,
    ));
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.sp),
          child: SingleChildScrollView(
            child: RichText(
              text: const WidgetSpan(
                child: Text(
                  pPolicy,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
