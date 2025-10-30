import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/login_screen.dart';
import '../profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem extends StatefulWidget {
  final String text;
  const DrawerItem({required this.text, super.key});

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  String? selectedLanguage;
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
      selectedLanguage = prefs.getString('language') ?? 'English';
      selectedTheme = prefs.getString('theme') ?? 'Light Mode';
      selectedNotification = prefs.getString('notification') ?? 'Enable';
    });
  }

  Future<void> _savePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void _updatePreference(String key, String value) {
    _savePreference(key, value);
    setState(() {
      if (key == 'language') selectedLanguage = value;
      if (key == 'theme') selectedTheme = value;
      if (key == 'notification') selectedNotification = value;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return GestureDetector(
      onTap: () {
        if (text == "Profile") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (text == "Language" ||
            text == "Notification" ||
            text == "Color Theme" ||
            text == "Rate Us" ||
            text == "Logout") {
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
                      text == "Language"
                          ? 'Choose Language'
                          : text == "Notification"
                          ? 'Notifications'
                          : text == "Color Theme"
                          ? 'Choose Theme'
                          : text == "Logout"
                          ? 'Are You Sure?'
                          : 'Rate Us',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🌍 LANGUAGE OPTIONS
                    if (text == "Language") ...[
                      _buildOptionTile(
                        title: "English",
                        keyName: "language",
                        selectedValue: selectedLanguage,
                      ),
                      _buildOptionTile(
                        title: "Arabic",
                        keyName: "language",
                        selectedValue: selectedLanguage,
                      ),
                    ]

                    // 🔔 NOTIFICATION OPTIONS
                    else if (text == "Notification") ...[
                      _buildOptionTile(
                        title: "Enable",
                        keyName: "notification",
                        selectedValue: selectedNotification,
                      ),
                      _buildOptionTile(
                        title: "Turn Off",
                        keyName: "notification",
                        selectedValue: selectedNotification,
                      ),
                    ]

                    // 🎨 THEME OPTIONS
                    else if (text == "Color Theme") ...[
                        _buildOptionTile(
                          title: "Light Mode",
                          keyName: "theme",
                          selectedValue: selectedTheme,
                        ),
                        _buildOptionTile(
                          title: "Dark Mode",
                          keyName: "theme",
                          selectedValue: selectedTheme,
                        ),
                      ]

                      // ⭐ RATING OPTIONS
                      else if (text == "Rate Us") ...[
                          _RatingStars(),
                        ]

                        // 🚪 LOGOUT OPTIONS
                        else if (text == "Logout") ...[
                            ListTile(
                              title: const Text('Logout'),
                              onTap: () async {
                                Navigator.pop(context);
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                      (route) => false,
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Cancel'),
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
          color: Colors.pinkAccent,
          fontSize: 20,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String keyName,
    required String? selectedValue,
  }) {
    final bool isSelected = selectedValue == title;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primaryBlue : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primaryBlue)
          : null,
      onTap: () => _updatePreference(keyName, title),
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
                    content:
                    Text('Thank you for rating us ${index + 1} stars!'),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          _selectedStars == 0
              ? 'Tap a star to rate the app!'
              : 'You rated $_selectedStars ⭐',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
