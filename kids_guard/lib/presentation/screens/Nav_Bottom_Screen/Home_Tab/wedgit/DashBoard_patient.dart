import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/health_box.dart';

class DashboardPatient extends StatelessWidget {
  String perecenetage;
  String symbol;
  String text;
  DashboardPatient({
    required this.perecenetage,
    required this.symbol,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 120,
      child: HealthBox(
        boxColor: AppColors.HomeScreenBg,
        perenctage: perecenetage,
        symbol: symbol,
        text: text,
      ),
    );
  }
}
