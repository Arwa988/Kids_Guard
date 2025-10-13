import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PeopleAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/lottie/MicrointeractionsIcon.json",
        width: 50,
        height: 50,
      ),
    );
  }
}
