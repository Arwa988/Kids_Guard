import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/Guardin_Screen.dart';
import 'package:kids_guard/presentation/screens/provider/app_conf_provider.dart';
import 'package:provider/provider.dart';

class LangugeScreen extends StatefulWidget {
  static const String routname = "/languge";

  const LangugeScreen({super.key});

  @override
  State<LangugeScreen> createState() => _LangugeScreenState();
}

class _LangugeScreenState extends State<LangugeScreen> {
  @override
  void initState() {
    super.initState();
    // يمكنك تحميل اللغة المحفوظة إذا أردت
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    // يمكنك إضافة تحميل اللغة المحفوظة هنا إذا لزم الأمر
    await Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfProvider>(context, listen: false);
    final currentLanguage = provider.appLanguage;

    // تحديد لون الخلفية بناءً على اللغة الحالية
    Color backgroundColor;
    if (currentLanguage == 'en') {
      backgroundColor = AppColors.splashScreenLinearBlue.withOpacity(0.1);
    } else if (currentLanguage == 'ar') {
      backgroundColor = Colors.green.withOpacity(0.1);
    } else {
      backgroundColor = AppColors.background;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const CloudDesgin(),

          /// Center Card
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 309,
              height: 288,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.choose_lang,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Lexend",
                        color: AppColors.splashScreenLinearBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// English
                    _buildOption(
                      context: context,
                      languageCode: 'en',
                      label: AppLocalizations.of(context)!.eng,
                      icon: Icons.language,
                      selectedColor: AppColors.splashScreenLinearBlue,
                    ),

                    const SizedBox(height: 20),

                    /// Arabic
                    _buildOption(
                      context: context,
                      languageCode: 'ar',
                      label: AppLocalizations.of(context)!.arb,
                      icon: Icons.translate,
                      selectedColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Next Button
          Container(
            margin: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 91,
                height: 49,
                child: ElevatedButton(
                  onPressed: () {
                    // التحقق مما إذا كانت اللغة قد تم اختيارها
                    if (provider.appLanguage == 'en' ||
                        provider.appLanguage == 'ar') {
                      Navigator.pushReplacementNamed(
                        context,
                        GuardinScreen.routname,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.choose_lang,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.next,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Lexend",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Option Widget مع دمج وظيفة تغيير اللغة
  Widget _buildOption({
    required BuildContext context,
    required String languageCode,
    required String label,
    required IconData icon,
    required Color selectedColor,
  }) {
    var provider = Provider.of<AppConfProvider>(context, listen: true);
    final bool isSelected = provider.appLanguage == languageCode;

    return GestureDetector(
      onTap: () {
        // تغيير اللغة باستخدام Provider
        provider.changeLanguage(languageCode);
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 15),
                Icon(
                  icon,
                  color: isSelected ? selectedColor : Colors.grey.shade600,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "Lexend",
                    color: isSelected ? selectedColor : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            /// Check Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              child: isSelected
                  ? Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: selectedColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedColor, width: 1.2),
                      ),
                      child: Icon(Icons.check, color: selectedColor, size: 14),
                    )
                  : const SizedBox(width: 22, height: 22),
            ),
          ],
        ),
      ),
    );
  }
}
