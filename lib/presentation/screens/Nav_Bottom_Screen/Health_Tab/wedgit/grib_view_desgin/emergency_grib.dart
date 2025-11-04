import 'package:flutter/material.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/Articles_Details/EmergencyProgress.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/card_desgin/card_desgin_emergency.dart';
import 'package:shimmer/shimmer.dart';

class EmergencyGrib extends StatelessWidget {
  final List<EmergencyData> emergencyList;

  const EmergencyGrib({required this.emergencyList, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: emergencyList.length,
      itemBuilder: (context, index) {
        final item = emergencyList[index];

        // 🩵 shimmer if loading
        // ✅ real card when loaded
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Emergencyprogress.routname,
              arguments: item,
            );
          },
          child: CardDesginEmergency(emergencyData: item),
        );
      },
    );
  }
}
