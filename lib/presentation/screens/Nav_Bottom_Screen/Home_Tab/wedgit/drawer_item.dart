import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import '../profile_screen.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  const DrawerItem({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == "Profile") {
          // Close drawer before navigating
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

                    // 💬 LANGUAGE OPTIONS
                    if (text == "Language") ...[
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Arabic'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]

                    // 🔔 NOTIFICATION OPTIONS
                    else if (text == "Notification") ...[
                      ListTile(
                        title: const Text('Turn On'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('None'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]

                    // 🎨 THEME OPTIONS
                    else if (text == "Color Theme") ...[
                        ListTile(
                          title: const Text('Light Mode'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Dark Mode'),
                          onTap: () {
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
                              onTap: () {
                                Navigator.pop(context);
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

