import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';
import 'package:readmore/readmore.dart';

class CardDesginLifestyle extends StatelessWidget {
  final lifestyleData lifeData;

  const CardDesginLifestyle({Key? key, required this.lifeData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // ✅ space between cards
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
            // ✅ Top image with caching
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: lifeData.image ?? "",
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

            // ✅ Title and content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                lifeData.title ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                maxLines: 2,
              ),
            ),

            // ✅ Source
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                lifeData.source ?? "",
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
                lifeData.content ?? "",
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
