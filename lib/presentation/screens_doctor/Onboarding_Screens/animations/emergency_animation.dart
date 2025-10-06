import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmergencyAnimationDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/lottie/ambulancia1.json",
        width: 350,
        height: 350,
      ),
    );
  }
}
