import 'package:flutter/widgets.dart';
import 'package:kids_guard/data/model/FamilyResponse.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Card_Desgin_Doc/FamilyCard_Desgin.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Articles_Detalis_Doc/familyProgress.dart';

// ignore: must_be_immutable
class Familygrib extends StatelessWidget {
  List<FamilyData> FamilyList;
  Familygrib({required this.FamilyList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // ✅ fits content
      physics: const NeverScrollableScrollPhysics(), // ✅ prevents nested scroll
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: FamilyList.length,

      // ✅ Add vertical spacing between cards
      separatorBuilder: (context, index) => const SizedBox(height: 20),

      itemBuilder: (context, index) {
        final family = FamilyList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Familyprogress.routname,
              arguments: family,
            );
          },
          child: FamilycardDesgin(familyData: family),
        );
      },
    );
  }
}
