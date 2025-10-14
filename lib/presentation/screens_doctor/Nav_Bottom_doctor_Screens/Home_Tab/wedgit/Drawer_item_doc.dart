import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';

class DrawerItemDoc extends StatelessWidget {
  String text;

  DrawerItemDoc({required this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
