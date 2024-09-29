import 'package:gozip/core/constants/lottie_img.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/domain/repository/connectivity_helper.dart';
import 'package:gozip/presentation/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Lottie.asset(AppLottie.noNetwork),
          DelevatedButton(
              text: "Retry",
              onTap: () {
                ConnectivityHelper.clareStackPush(context, Routes.homeRoute);
              })
        ],
      ),
    );
  }
}
