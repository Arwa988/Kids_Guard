import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/provider/app_conf_provider.dart';
import 'package:kids_guard/presentation/screens_doctor/Login_doctor_screen/login_doctor.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/profile_screen_doc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItemDoc extends StatefulWidget {
  final String text;
  const DrawerItemDoc({required this.text, super.key});

  @override
  State<DrawerItemDoc> createState() => _DrawerItemDocState();
}

class _DrawerItemDocState extends State<DrawerItemDoc> {
  String? selectedLanguage; // سيكون كود اللغة مثل 'en' أو 'ar'
  String? selectedTheme;
  String? selectedNotification;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage =
          prefs.getString('language') ?? 'en'; // الافتراضي انجليزي
      selectedTheme = prefs.getString('theme') ?? 'Light Mode';
      selectedNotification = prefs.getString('notification') ?? 'Enable';
    });
  }

  Future<void> _savePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    setState(() {
      if (key == 'language') selectedLanguage = value;
      if (key == 'theme') selectedTheme = value;
      if (key == 'notification') selectedNotification = value;
    });
  }

  void _updatePreference(String key, String value) {
    _savePreference(key, value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    var provider = Provider.of<AppConfProvider>(context);

    return GestureDetector(
      onTap: () {
        if (text == AppLocalizations.of(context)!.profile) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreenDoc()),
          );
        } else if (text == AppLocalizations.of(context)!.lang ||
            text == AppLocalizations.of(context)!.notfication ||
            text == AppLocalizations.of(context)!.color_theme ||
            text == AppLocalizations.of(context)!.rate_us ||
            text == AppLocalizations.of(context)!.log) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text == AppLocalizations.of(context)!.lang
                          ? AppLocalizations.of(context)!.choose_lang
                          : text == AppLocalizations.of(context)!.notfication
                          ? AppLocalizations.of(context)!.notfication
                          : text == AppLocalizations.of(context)!.color_theme
                          ? AppLocalizations.of(context)!.color_theme
                          : text == AppLocalizations.of(context)!.log
                          ? AppLocalizations.of(context)!.sure
                          : AppLocalizations.of(context)!.rate_us,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 💬 LANGUAGE OPTIONS
                    // 🌍 LANGUAGE OPTIONS
                    if (text == AppLocalizations.of(context)!.lang) ...[
                      // خيار الإنجليزية
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.eng,
                          style: TextStyle(
                            color: selectedLanguage == 'en'
                                ? AppColors.primaryBlue
                                : Colors.black87,
                            fontWeight: selectedLanguage == 'en'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: selectedLanguage == 'en'
                            ? const Icon(
                                Icons.check,
                                color: AppColors.primaryBlue,
                              )
                            : null,
                        onTap: () async {
                          await _savePreference('language', 'en');
                          provider.changeLanguage("en");
                          Navigator.pop(context);
                        },
                      ),
                      // خيار العربية
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.arb,
                          style: TextStyle(
                            color: selectedLanguage == 'ar'
                                ? AppColors.primaryBlue
                                : Colors.black87,
                            fontWeight: selectedLanguage == 'ar'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: selectedLanguage == 'ar'
                            ? const Icon(
                                Icons.check,
                                color: AppColors.primaryBlue,
                              )
                            : null,
                        onTap: () async {
                          await _savePreference('language', 'ar');
                          provider.changeLanguage("ar");
                          Navigator.pop(context);
                        },
                      ),
                    ]
                    // 🔔 NOTIFICATION OPTIONS
                    else if (text ==
                        AppLocalizations.of(context)!.notfication) ...[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.enable),
                        trailing: selectedNotification == 'Enable'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => selectedNotification = 'Enable');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.turn_off),
                        trailing: selectedNotification == 'Turn Off'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => selectedNotification = 'Turn Off');
                          Navigator.pop(context);
                        },
                      ),
                    ]
                    // 🎨 THEME OPTIONS
                    else if (text ==
                        AppLocalizations.of(context)!.color_theme) ...[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.light),
                        trailing: selectedTheme == 'Light Mode'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => selectedTheme = 'Light Mode');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.dark),
                        trailing: selectedTheme == 'Dark Mode'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => selectedTheme = 'Dark Mode');
                          Navigator.pop(context);
                        },
                      ),
                    ]
                    // ⭐ RATING OPTIONS
                    else if (text == AppLocalizations.of(context)!.rate_us) ...[
                      _RatingStars(),
                    ]
                    // 🚪 LOGOUT OPTIONS
                    else if (text == AppLocalizations.of(context)!.log) ...[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.log),
                        onTap: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreenDoctor(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.cancel),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}

class _RatingStars extends StatefulWidget {
  @override
  State<_RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<_RatingStars> {
  int _selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _selectedStars ? Icons.star : Icons.star_border,
                size: 32,
              ),
              color: AppColors.primaryBlue,
              onPressed: () {
                setState(() {
                  _selectedStars = index + 1;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Thank you for rating us ${index + 1} stars!',
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          _selectedStars == 0
              ? AppLocalizations.of(context)!.tap_rate
              : 'You rated $_selectedStars ⭐',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
