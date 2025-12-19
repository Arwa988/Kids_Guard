import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:readmore/readmore.dart';

class CardDesginEmergency extends StatelessWidget {
  final EmergencyData emergencyData;
  final int cardIndex;

  const CardDesginEmergency({
    required this.emergencyData,
    required this.cardIndex,
    Key? key,
  }) : super(key: key);

  static const List<String> defaultImages = [
    "assets/images/faint.png",
    "assets/images/cpr.png",
    "assets/images/arrest.png",
    "assets/images/hearthealth2.png",
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ التحقق من لغة التطبيق
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
          // ✅ تغيير اتجاه العناصر حسب اللغة
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
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

            // ✅ العنوان المترجم
            // ✅ العنوان (Title)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity, // تأكدي إن النص واخد عرض الكارت كله
                child: Text(
                  isArabic
                      ? emergencyData.titleAr
                      : (emergencyData.title ?? ""),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  // ✅ ده السطر اللي هيظبط الاتجاه
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  // نستخدم الـ Getter المترجم من الموديل
                  isArabic
                      ? emergencyData.sourceAr
                      : (emergencyData.source ?? "Medical Source"),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.kPrimaryColor, // اللون الأساسي للتطبيق
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),
            ),

            // ✅ المحتوى المترجم (Content) - تم تعديل المحاذاة لتبدأ من اليمين
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width:
                    double.infinity, // لضمان أن النص يملأ العرض ويتحاذى لليمين
                child: ReadMoreText(
                  isArabic
                      ? emergencyData.contentListAr.join("\n")
                      : (emergencyData.contentList ?? []).join("\n"),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  trimLines: 2,
                  trimMode: TrimMode.Line,

                  // ✅ التعديل الأساسي هنا
                  textAlign: isArabic
                      ? TextAlign.right
                      : TextAlign.left, // محاذاة النص لليمين
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr, // اتجاه النص من اليمين لليسار

                  trimCollapsedText: '',
                  postDataText: AppLocalizations.of(context)!.read_more,
                  postDataTextStyle: TextStyle(
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                  trimExpandedText: "",
                  colorClickableText: AppColors.errorRed,
                  moreStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
