import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';

// ignore: must_be_immutable
class Patient extends StatelessWidget {
  String text;
  String number;
  Color bgColor;
  Patient({required this.text, required this.number, required this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 114,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(number, style: TextStyle(fontSize: 50)),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: AppColors.kTextColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
