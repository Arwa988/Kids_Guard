import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FitnessAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Lottie.asset(
        "assets/lottie/Fitnesstracker.json",
        width: 260,
        height: 260,
      ),
    );
  }
}
