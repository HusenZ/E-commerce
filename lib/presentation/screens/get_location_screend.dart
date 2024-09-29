import 'package:flutter/material.dart';
import 'package:gozip/core/constants/lottie_img.dart';
import 'package:lottie/lottie.dart';

class GetLocationScreen extends StatefulWidget {
  final VoidCallback getLocation;
  const GetLocationScreen({super.key, required this.getLocation});

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              child: Lottie.asset(AppLottie.locationLottie),
            ),
          ),
          ElevatedButton(
            onPressed: widget.getLocation,
            child: const Text("Allow Location"),
          )
        ],
      ),
    );
  }
}
