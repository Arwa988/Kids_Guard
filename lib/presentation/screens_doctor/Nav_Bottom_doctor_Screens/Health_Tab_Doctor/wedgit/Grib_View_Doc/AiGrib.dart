import 'package:flutter/widgets.dart';
import 'package:kids_guard/data/model/AiResponse.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Articles_Detalis_Doc/AiProgress.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Card_Desgin_Doc/AiCard_Desgin.dart';

// ignore: must_be_immutable
class Aigrib extends StatelessWidget {
  List<AIData> AIList;
  Aigrib({required this.AIList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // ✅ fits content
      physics: const NeverScrollableScrollPhysics(), // ✅ prevents nested scroll
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: AIList.length,

      // ✅ Add vertical spacing between cards
      separatorBuilder: (context, index) => const SizedBox(height: 20),

      itemBuilder: (context, index) {
        final ai = AIList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Aiprogress.routname, arguments: ai);
          },
          child: AicardDesgin(aiData: ai),
        );
      },
    );
  }
}
