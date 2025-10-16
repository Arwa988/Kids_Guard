import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';

class DrawerItem extends StatelessWidget {
  String text;

  DrawerItem({required this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 79, 215),
          fontSize: 20,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
