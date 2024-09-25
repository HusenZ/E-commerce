import 'package:gozip/presentation/screens/auth_screen/login_screen.dart';
import 'package:gozip/presentation/screens/auth_screen/set_profile_screen.dart';
import 'package:gozip/presentation/screens/customer_support.dart';
import 'package:gozip/presentation/screens/index.dart';
import 'package:gozip/presentation/screens/onboarding_screen.dart';
import 'package:gozip/presentation/screens/privacy_policy.dart';
import 'package:gozip/presentation/screens/terms_condi.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String authRoute = '/login';
  static const String ordersRoute = '/order';
  static const String otpLoginRoute = '/otpLogin';
  static const String setProfileRoute = '/profilePhoto';
  static const String homeRoute = '/home';
  static const String productRoute = '/product';
  static const String noInternetRoute = '/noInternet';
  static const String checkout = '/checkout';
  static const String shopsRoute = '/shopsRoute';
  static const String emailRoute = '/setEmailUser';
  static const String privacyRoute = '/privacy';
  static const String termsRoute = '/terms';
  static const String support = '/support';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.noInternetRoute: (context) => const NoNetwork(),
    Routes.splashRoute: (context) => const SplashScreen(),
    Routes.authRoute: (context) => const LoginScreen(),
    Routes.homeRoute: (context) => const HomeScreen(),
    Routes.checkout: (context) => const CheckoutScreen(),
    Routes.setProfileRoute: (context) => const SetProfileScreen(),
    Routes.ordersRoute: (context) => const OrderScreen(),
    Routes.shopsRoute: (context) => const ShopsScreen(),
    Routes.onboardingRoute: (context) => const OnboardingScreen(),
    Routes.privacyRoute: (context) => const PrivacyPolicy(),
    Routes.termsRoute: (context) => const TermsAndConditoins(),
    Routes.support: (context) => const CustomerSupport(),
  };
}
