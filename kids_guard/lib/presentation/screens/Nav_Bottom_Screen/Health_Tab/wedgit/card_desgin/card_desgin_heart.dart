import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:readmore/readmore.dart';

class CardDesginHeart extends StatelessWidget {
  final Data articleData;

  const CardDesginHeart({required this.articleData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 315,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
         side: BorderSide(color: Color(0xFF818589)),
         
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Cached image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: articleData.image ?? "",
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,

                errorWidget: (context, url, error) => Container(
                  height: 140,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            // ✅ Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                articleData.title ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                maxLines: 2,
              ),
            ),

            // ✅ Source
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                articleData.source ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
              ),
            ),

            // ✅ Read more
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                articleData.content ?? "",
                style: const TextStyle(color: Colors.grey),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: '',
                postDataText: "Read More",
                postDataTextStyle: TextStyle(color: AppColors.errorRed),
                moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                colorClickableText: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
