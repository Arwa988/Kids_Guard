import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/Articles_Details/ArticleWithProgress.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/card_desgin/card_desgin_heart.dart';

class HeartGribbulider extends StatelessWidget {
  final List<Data> articleList;

  const HeartGribbulider({Key? key, required this.articleList})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // ✅ fits content
      physics: const NeverScrollableScrollPhysics(), // ✅ prevents nested scroll
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: articleList.length,

      // ✅ Add vertical spacing between cards
      separatorBuilder: (context, index) => const SizedBox(height: 20),

      itemBuilder: (context, index) {
        final article = articleList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ArticleWithProgress.routname,
              arguments: article,
            );
          },
          child: CardDesginHeart(articleData: article),
        );
      },
    );
  }
}
