import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeDetector extends StatelessWidget {
  Widget DetectorAnimation;
  String text;
  HomeDetector({required this.DetectorAnimation, required this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            DetectorAnimation,
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 10,
                fontFamily: "Lexend",
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
