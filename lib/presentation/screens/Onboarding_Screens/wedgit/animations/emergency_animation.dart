import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmergencyAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/lottie/ambulancia.json",
        width: 350,
        height: 350,
      ),
    );
  }
}
