import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:readmore/readmore.dart';

class CardDesginLifestyle extends StatelessWidget {
  final lifestyleData lifeData;

  const CardDesginLifestyle({Key? key, required this.lifeData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ تحديد لغة التطبيق
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
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // ✅ الصورة مع التخزين المؤقت
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

            // ✅ العنوان (مترجم بناءً على اللغة)
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  isArabic ? lifeData.titleAr : (lifeData.title ?? ""),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // ✅ المصدر (Source) - مضاف حديثاً
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  isArabic ? lifeData.sourceAr : (lifeData.source ?? ""),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.kPrimaryColor,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),
            ),

            // ✅ المحتوى و "إقرأ المزيد"
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                isArabic ? lifeData.contentAr : (lifeData.content ?? ""),
                style: const TextStyle(color: Colors.grey),
                trimLines: 2,
                trimMode: TrimMode.Line,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                trimCollapsedText: '',
                postDataText: AppLocalizations.of(context)!.read_more,
                postDataTextStyle: TextStyle(color: AppColors.errorRed),
                trimExpandedText: ' ',
                colorClickableText: AppColors.errorRed,
                moreStyle: TextStyle(
                  fontSize: 14,
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
