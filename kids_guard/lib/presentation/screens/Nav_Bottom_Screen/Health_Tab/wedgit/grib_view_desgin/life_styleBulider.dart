import 'package:flutter/material.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/Articles_Details/ArticleWithProgress.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/Articles_Details/LifeStyleProgress.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/card_desgin/card_desgin_lifestyle.dart';

class LifeStylebulider extends StatelessWidget {
  final List<lifestyleData> lifeArticles;
  LifeStylebulider({required this.lifeArticles});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // ✅ fits content
      physics: const NeverScrollableScrollPhysics(), // ✅ prevents nested scroll
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: lifeArticles.length,

      // ✅ Add vertical spacing between cards
      separatorBuilder: (context, index) => const SizedBox(height: 20),

      itemBuilder: (context, index) {
        final life = lifeArticles[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Lifestyleprogress.routname,
              arguments: life,
            );
          },
          child: CardDesginLifestyle(lifeData: life),
        );
      },
    );
  }
}
