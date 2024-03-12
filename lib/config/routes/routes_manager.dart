import 'package:daprot_v1/features/screens/auth_screen/login_screen.dart';
import 'package:daprot_v1/features/screens/auth_screen/otp_screen.dart';
import 'package:daprot_v1/features/screens/auth_screen/set_profile_screen.dart';
import 'package:daprot_v1/features/screens/home_screen.dart';
import 'package:daprot_v1/features/screens/no_network.dart';
import 'package:daprot_v1/features/screens/splash_screen.dart';
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
  static const String noInternetRoute = '/noInternet';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.noInternetRoute: (context) => const NoNetwork(),
    Routes.splashRoute: (context) => const SplashScreen(),
    Routes.authRoute: (context) => const LoginScreen(),
    Routes.homeRoute: (context) => const HomeScreen(),
    Routes.otpRoute: (context) => const OtpScreen(),
    Routes.setProfileRoute: (context) => const SetProfileScreen(),
  };
}
