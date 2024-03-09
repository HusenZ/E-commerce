import 'package:daprot_v1/features/screens/home_screen.dart';
import 'package:daprot_v1/features/screens/procut_details_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String authRoute = '/login';
  static const String otpRoute = '/otp';
  static const String otpLoginRoute = '/otpLogin';
  static const String setProfileRoute = '/profilePhoto';
  static const String homeRoute = '/home';
  static const String productRoute = '/product';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.homeRoute: (context) => const HomeScreen(),
    // Routes.productRoute: (context) => const ProductScreen(),
  };
}
