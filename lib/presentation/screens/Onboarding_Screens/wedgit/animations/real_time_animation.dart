import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RealTimeAnimation extends StatelessWidget {
  const RealTimeAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/lottie/bloodpressure.json",width: 250,height: 250));
  }
}
