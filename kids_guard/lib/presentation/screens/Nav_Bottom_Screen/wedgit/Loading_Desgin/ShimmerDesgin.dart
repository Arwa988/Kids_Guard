import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmerdesgin extends StatelessWidget {
  const Shimmerdesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blueGrey[300]!,
      highlightColor: Colors.blueGrey[100]!,
      period: Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        width: 500,
        height: 300,
      ),
    );
  }
}
