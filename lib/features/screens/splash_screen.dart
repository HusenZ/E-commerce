import 'package:daprot_v1/config/routes/routes_manager.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnimationPlaying = true;

  @override
  void initState() {
    super.initState();

    navigation();
  }

  Future navigation() {
    return Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, Routes.authRoute);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.whiteColor, ColorsManager.secondaryColor],
            begin: Alignment(0.0, 0.0),
            end: Alignment(0.0, 1.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // LottieBuilder.asset(
                  //   LottieImages.logo,
                  //   width: double.infinity,
                  //   onLoaded: (composition) {
                  //     // The animation has loaded
                  //     setState(() {
                  //       _isAnimationPlaying = false; // Stop the animation
                  //     });
                  //   },
                  //   repeat: false,
                  //   reverse: false,
                  // ),
                  CopyRights(isAnimationPlaying: _isAnimationPlaying),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: Lottie.asset(
                    LottieImages.splashScreenBottom,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LottieImages {
  static const splashScreenBottom = 'assets/lottie/splashScreenBottom.json';
  static const logo = '';
}

class CopyRights extends StatelessWidget {
  const CopyRights({
    super.key,
    required bool isAnimationPlaying,
  }) : _isAnimationPlaying = isAnimationPlaying;

  final bool _isAnimationPlaying;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.5.sp),
      child: !_isAnimationPlaying
          ? const Text(
              '© 2024 DAPROT, Inc.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          : const SizedBox(),
    );
  }
}
