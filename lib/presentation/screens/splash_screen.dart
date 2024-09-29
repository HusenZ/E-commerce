import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/domain/repository/connectivity_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    navigation();
  }

  bool? locationExists;
  Future<void> navigation() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final bool isAuthenticated =
          preferences.getBool('isAuthenticated') ?? false;
      print("preferences: $isAuthenticated");
      String? locality = preferences.getString('locality');
      locationExists = locality == null;

      if (isAuthenticated) {
        if (mounted) {
          const String homeRoute = Routes.homeRoute;
          ConnectivityHelper.replaceIfConnected(context, homeRoute);
        }
      } else {
        if (mounted) {
          const String onboarding = Routes.onboardingRoute;
          ConnectivityHelper.replaceIfConnected(context, onboarding);
        }
      }
    } catch (e) {
      // Handle any potential errors here
      print('Error navigating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.fill,
          height: 40.w,
          width: 40.w,
        ),
      ),
    );
  }
}

// class CopyRights extends StatelessWidget {
//   const CopyRights({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.only(right: 4.5.sp),
//         child: const Text(
//           '© 2024 DAPROT, Inc.',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ));
//   }
// }
