import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:readmore/readmore.dart';

class CardDesginHeart extends StatelessWidget {
  final Data articleData;

  const CardDesginHeart({required this.articleData, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ نعرف لغة التطبيق الحالية
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المقال
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: articleData.image ?? "",
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 140,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            // ✅ العنوان (مترجم)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isArabic ? articleData.titleAr : (articleData.title ?? ""),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
            // ✅ المصدر (Source) - مضاف حديثاً ويبدأ من اليمين دائماً
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  // تأكدي من إضافة getter اسمه sourceAr في موديل EmergencyData
                  isArabic
                      ? (articleData.sourceAr ?? "")
                      : (articleData.source ?? ""),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.kPrimaryColor,
                  ),
                  textAlign: TextAlign.right, // يمين دائماً
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            // ✅ المحتوى مع Read More الأصلية
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(
                isArabic ? articleData.contentAr : (articleData.content ?? ""),
                style: TextStyle(color: Colors.grey),
                trimLines: 2,
                trimMode: TrimMode.Line,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                // ✅ استرجاع الإعدادات الأصلية هنا
                trimCollapsedText: '',

                postDataText: AppLocalizations.of(context)!.read_more,

                postDataTextStyle: TextStyle(color: AppColors.errorRed),
                trimExpandedText: ' ', // فراغ بسيط بعد التوسيع
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorRed, // اللون الأحمر الأصلي
                ),
                lessStyle: TextStyle(
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
