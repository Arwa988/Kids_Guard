import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeAppBarAnimation extends StatelessWidget {
  final String lottiePath;

  const HomeAppBarAnimation({
    required this.lottiePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        lottiePath,
        width: 200,
        height: 70,
      ),
    );
  }
}
