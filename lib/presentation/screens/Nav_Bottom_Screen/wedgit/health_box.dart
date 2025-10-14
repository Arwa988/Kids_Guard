import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HealthBox extends StatelessWidget {
  Color boxColor;
  String text;
  String perenctage;
  String symbol;
  HealthBox({
    required this.boxColor,
    required this.perenctage,
    required this.symbol,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 113,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 0.3, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  perenctage,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 32),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text(symbol)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
