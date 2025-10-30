import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Login_doctor_screen/login_doctor.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/profile_screen_doc.dart';

class DrawerItemDoc extends StatefulWidget {
  final String text;
  const DrawerItemDoc({required this.text, super.key});

  @override
  State<DrawerItemDoc> createState() => _DrawerItemDocState();
}

class _DrawerItemDocState extends State<DrawerItemDoc> {
  String _selectedLanguage = 'English';
  String _selectedNotification = 'Enable';
  String _selectedTheme = 'Light Mode';

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return GestureDetector(
      onTap: () {
        if (text == "Profile") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreenDoc()),
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

                    // 💬 LANGUAGE OPTIONS
                    if (text == "Language") ...[
                      ListTile(
                        title: const Text('English'),
                        trailing: _selectedLanguage == 'English'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => _selectedLanguage = 'English');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Arabic'),
                        trailing: _selectedLanguage == 'Arabic'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => _selectedLanguage = 'Arabic');
                          Navigator.pop(context);
                        },
                      ),
                    ]

                    // 🔔 NOTIFICATION OPTIONS
                    else if (text == "Notification") ...[
                      ListTile(
                        title: const Text('Enable'),
                        trailing: _selectedNotification == 'Enable'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => _selectedNotification = 'Enable');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Turn Off'),
                        trailing: _selectedNotification == 'Turn Off'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          setState(() => _selectedNotification = 'Turn Off');
                          Navigator.pop(context);
                        },
                      ),
                    ]

                    // 🎨 THEME OPTIONS
                    else if (text == "Color Theme") ...[
                        ListTile(
                          title: const Text('Light Mode'),
                          trailing: _selectedTheme == 'Light Mode'
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            setState(() => _selectedTheme = 'Light Mode');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Dark Mode'),
                          trailing: _selectedTheme == 'Dark Mode'
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            setState(() => _selectedTheme = 'Dark Mode');
                            Navigator.pop(context);
                          },
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
                                    builder: (context) => LoginScreenDoctor(),
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
                    content: Text('Thank you for rating us ${index + 1} stars!'),
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
