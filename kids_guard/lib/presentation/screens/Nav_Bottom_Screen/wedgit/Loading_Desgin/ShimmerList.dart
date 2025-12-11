import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerDesgin.dart';

class ShimmerList extends StatelessWidget {
  final int count; // number of shimmer cards

  const ShimmerList({required this.count, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: count,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Shimmerdesgin(),
        );
      },
    );
  }
}
