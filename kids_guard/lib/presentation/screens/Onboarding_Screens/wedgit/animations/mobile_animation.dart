import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MobileAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 107,
      left: 78,
      child: Lottie.asset(
        "assets/lottie/mobilemonitor.json",
        width: 160,
        height: 160,
      ),
    );
  }
}
