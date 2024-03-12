import 'package:daprot_v1/config/constants/lottie_img.dart';
import 'package:daprot_v1/domain/connectivity_helper.dart';
import 'package:daprot_v1/features/widgets/common_widgets/delevated_button.dart';
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
                ConnectivityHelper.popIfConnected(context);
              })
        ],
      ),
    );
  }
}
