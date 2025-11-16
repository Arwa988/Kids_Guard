import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorlistAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/lottie/Needdoctor.json",
        width: 210,
        height: 210,
      ),
    );
  }
}
