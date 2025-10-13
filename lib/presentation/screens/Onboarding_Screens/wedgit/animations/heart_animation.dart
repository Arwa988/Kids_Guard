import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeartAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Lottie.asset(
        "assets/lottie/HeartRate.json",
        width: 150,
        height: 150,
      ),
    );
  }
}
