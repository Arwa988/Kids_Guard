import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeDetector extends StatelessWidget {
  final Widget DetectorAnimation;
  final String text;
  final VoidCallback? onTap; // ← أضفنا ده

  HomeDetector({
    required this.DetectorAnimation,
    required this.text,
    this.onTap, // ← أضفنا ده
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DetectorAnimation,
            const SizedBox(height: 6),
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 10,
                    fontFamily: "Lexend",
                    fontWeight: FontWeight.w800,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
