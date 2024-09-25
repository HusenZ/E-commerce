import 'package:gozip/core/constants/polycies/terms_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditoins extends StatelessWidget {
  const TermsAndConditoins({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 218, 40, 40),
      statusBarIconBrightness: Brightness.light,
    ));
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: RichText(
              text: const WidgetSpan(
                child: Text(
                  termsConditions,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
