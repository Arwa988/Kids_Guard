import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/Drawer_item_doc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerDesginDoctor extends StatelessWidget {
  const DrawerDesginDoctor({super.key});

  // ✅ Fetch doctor name from Firestore
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Unknown User";

    final firestore = FirebaseFirestore.instance;

    try {
      // Directly get document by UID
      final docSnap = await firestore.collection('doctors').doc(user.uid).get();

      if (docSnap.exists) {
        final data = docSnap.data()!;
        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        if (firstName.isNotEmpty || lastName.isNotEmpty) {
          return "$firstName $lastName".trim();
        }
      }
    } catch (e) {
      print("Error loading doctor name: $e");
    }

    return "Unknown User";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.textPrimary, AppColors.textSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // 👤 Doctor Info
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/hana.png"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _getUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            "Loading...",
                            style:
                            Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }

                        final name = snapshot.data ?? "Unknown User";
                        return Text(
                          "Dr. $name",
                          style:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // 📋 Drawer Items
              _drawerRow(
                icon: Icons.person,
                text: "Profile",
              ),
              _divider(),
              _drawerRow(
                icon: Icons.language,
                text: "Language",
              ),
              _divider(),
              _drawerRow(
                icon: Icons.notifications_rounded,
                text: "Notification",
              ),
              _divider(),
              _drawerRow(
                icon: Icons.palette_sharp,
                text: "Color Theme",
              ),
              _divider(),
              _drawerRow(
                icon: Icons.star_purple500_sharp,
                text: "Rate Us",
              ),
              _divider(),
              _drawerRow(
                icon: Icons.people,
                text: "Share with a friend",
              ),
              _divider(),
              _drawerRow(
                icon: Icons.login_outlined,
                text: "Logout",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Reusable row builder
  Widget _drawerRow({required IconData icon, required String text}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.pink,
          foregroundColor: AppColors.kPrimaryColor,
          child: Icon(icon),
        ),
        const SizedBox(width: 24),
        DrawerItemDoc(text: text),
      ],
    );
  }

  // ✅ Divider image between items
  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Image(
        image: AssetImage("assets/images/Line.png"),
      ),
    );
  }
}
