import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:readmore/readmore.dart';

class CardDesginEmergency extends StatelessWidget {
  final EmergencyData emergencyData;

  const CardDesginEmergency({required this.emergencyData, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // ✅ space between cards
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
            // ✅ Top image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                "assets/images/Ai3.png",
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                // errorBuilder: (context, error, stackTrace) => Container(
                //   height: 140,
                //   color: Colors.grey[200],
                //   alignment: Alignment.center,
                //   child: const Icon(Icons.broken_image, color: Colors.grey),
                // ),
              ),
            ),

            // ✅ Title and content
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
            // ✅ Title and content
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Text(
            //     emergencyData.source ?? "",
            //     style: const TextStyle(
            //       fontWeight: FontWeight.w400,
            //       fontSize: 14,
            //       color: Colors.black87,
            //     ),
            //     maxLines: 2,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                (emergencyData.contentList ?? []).join(
                  "\n",
                ), // ✅ join list into string
                style: const TextStyle(color: Colors.grey),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: '', // still visible
                postDataText: "Read More",
                postDataTextStyle: TextStyle(color: AppColors.errorRed),
                // no "Show less" after expansion
                moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                colorClickableText: Colors.transparent, // disables click
              ),
            ),
          ],
        ),
      ),
    );
  }
}
