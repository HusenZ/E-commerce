import 'package:daprot_v1/features/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String authRoute = '/login';
  static const String otpRoute = '/otp';
  static const String otpLoginRoute = '/otpLogin';
  static const String setProfileRoute = '/profilePhoto';
  static const String homeRoute = '/home';
  static const String foodCourtScreen = '/foodCourtScreen';
  static const String menuPage = '/menuPage';
  static const String blankPage = '/blankPage';
  static const String qrPage = '/qrPage';
  static const String qrResult = '/qrResult';
  static const String restaurentReviews = '/restreview';
  static const String ratingPage = '/rating';
  static const String reviewsPage = '/reviews';
  static const String searchPage = '/search';
  static const String locationAccessPage = '/locationAccess';
  static const String customerReviewsPage = '/customerReviews';
  static const String updateUserScreen = '/updateUser';
  static const String cartscreen = '/cartscreen';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.homeRoute: (context) => const HomeScreen()
  };
}
