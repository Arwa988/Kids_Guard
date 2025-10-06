import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

// ignore: must_be_immutable
class LangugeSelect extends StatelessWidget {
  String text;
  LangugeSelect({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.splashScreenLinearBlue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontFamily: "Lexend",
                color: AppColors.splashScreenLinearBlue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.splashScreenLinearBlue,
            ),
          ),
        ],
      ),
    );
  }
}
