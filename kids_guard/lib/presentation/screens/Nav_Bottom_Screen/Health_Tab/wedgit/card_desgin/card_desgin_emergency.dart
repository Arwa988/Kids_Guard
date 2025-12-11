import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:readmore/readmore.dart';

class CardDesginEmergency extends StatelessWidget {
  final EmergencyData emergencyData;
  final int cardIndex; // index of the article/card

  const CardDesginEmergency({
    required this.emergencyData,
    required this.cardIndex, // pass index to pick image
    Key? key,
  }) : super(key: key);

  // Four fixed asset images for the four articles
  static const List<String> defaultImages = [
    "assets/images/faint.png",
    "assets/images/cpr.png",
    "assets/images/arrest.png",
    "assets/images/hearthealth2.png",
  ];

  @override
  Widget build(BuildContext context) {
    // Pick image based on index
    final imageAsset = defaultImages[cardIndex % defaultImages.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 315,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF818589)),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                imageAsset,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                emergencyData.title ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                maxLines: 2,
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                (emergencyData.contentList ?? []).join("\n"),
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
