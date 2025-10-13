import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorlistAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/lottie/Medicinepreparation.json",
        width: 200,
        height: 200,
      ),
    );
  }
}
