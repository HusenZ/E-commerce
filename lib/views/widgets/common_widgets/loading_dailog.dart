import 'package:gozip/config/constants/lottie_img.dart';
import 'package:gozip/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsManager.transparentColor,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppLottie.locationLoading,
                  width: 90.w,
                  height: 60.w,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 15.h,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorsManager.offWhiteColor,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(seconds: 3),
                      animatedTexts: [
                        RotateAnimatedText('Fetching Location...'),
                        RotateAnimatedText('Getting Shops and Products Nearby'),
                        RotateAnimatedText('Almost There!...'),
                      ],
                      onTap: () {
                        debugPrint("Tap Event");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(child: CircularProgressIndicator()),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showOrderLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsManager.transparentColor,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppLottie.orderLoading,
                  width: 90.w,
                  height: 60.w,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 15.h,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorsManager.offWhiteColor,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(seconds: 3),
                      animatedTexts: [
                        RotateAnimatedText('Getting Products In Box'),
                        RotateAnimatedText('Almost There!...'),
                      ],
                      onTap: () {
                        debugPrint("Tap Event");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
