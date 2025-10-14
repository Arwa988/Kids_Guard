import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class HomeAppBarAnimation extends StatelessWidget {
  String LottiePath;
  HomeAppBarAnimation({required this.LottiePath});
  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(LottiePath, width: 200, height: 70));
  }
}
