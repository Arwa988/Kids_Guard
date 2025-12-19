import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/AiResponse.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:readmore/readmore.dart';

class AicardDesgin extends StatelessWidget {
  final AIData aiData;

  const AicardDesgin({required this.aiData, super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ تحديد اللغة الحالية لضبط الاتجاهات
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
          // ✅ ضبط اتجاه عناصر الكولوم بناءً على اللغة
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // صورة المقال
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: aiData.image ?? "",
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 140,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Icon(Icons.biotech, color: Colors.grey),
                ),
              ),
            ),

            // ✅ العنوان (Title)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  isArabic ? aiData.titleAr : (aiData.title ?? ""),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // ✅ المصدر (Source)
            // ✅ المصدر (Source) - مترجم ويبدأ من اليمين
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  isArabic ? aiData.sourceAr : (aiData.source ?? ""),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.kPrimaryColor,
                  ),
                  textAlign: TextAlign.right, // يمين دائماً كما طلبتِ
                  textDirection: TextDirection.rtl, // اتجاه اليمين
                ),
              ),
            ),

            // ✅ المحتوى المختصر مع ReadMore
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                isArabic ? aiData.contentAr : (aiData.content ?? ""),
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                trimLines: 2,
                trimMode: TrimMode.Line,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

                trimCollapsedText: '',

                postDataText: AppLocalizations.of(context)!.read_more,

                postDataTextStyle: TextStyle(color: AppColors.errorRed),
                moreStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorRed,
                ),
                lessStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
