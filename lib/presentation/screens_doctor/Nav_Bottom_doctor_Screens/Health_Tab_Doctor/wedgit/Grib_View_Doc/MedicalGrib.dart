import 'package:flutter/widgets.dart';
import 'package:kids_guard/data/model/MedicalResponse.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Articles_Detalis_Doc/MedProgress.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Card_Desgin_Doc/MedicalCard_Desgin.dart';

class Medicalgrib extends StatelessWidget {
  final List<MedicalData> MedicalDataList;

  Medicalgrib({required this.MedicalDataList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // ✅ fits content
      physics: const NeverScrollableScrollPhysics(), // ✅ prevents nested scroll
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: MedicalDataList.length,

      // ✅ Add vertical spacing between cards
      separatorBuilder: (context, index) => const SizedBox(height: 20),

      itemBuilder: (context, index) {
        final med = MedicalDataList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              MedicalProgess.routname,
              arguments: med,
            );
          },
          child: MedicalcardDesgin(medicalData: med),
        );
      },
    );
  }
}
