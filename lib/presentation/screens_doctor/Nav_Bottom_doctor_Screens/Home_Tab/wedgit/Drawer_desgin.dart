import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/Drawer_item_doc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerDesginDoctor extends StatelessWidget {
  const DrawerDesginDoctor({super.key});

  // Fetch doctor name from Firestore
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Unknown User";

    final firestore = FirebaseFirestore.instance;

    try {
      final docSnap = await firestore.collection('doctors').doc(user.uid).get();
      if (docSnap.exists) {
        final data = docSnap.data()!;
        final firstName = data['firstname'] ?? '';
        final lastName = data['lastname'] ?? '';
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
    const Color babyBlue = Color(0xFFB4CEFF);

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB4CEFF),
              Color(0xFFB4CEFF),
            ],
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
                        String displayName = "Loading...";
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          displayName = "Loading...";
                        } else if (snapshot.hasError) {
                          displayName = "Error";
                        } else if (snapshot.hasData) {
                          displayName = snapshot.data!;
                        }

                        return Text(
                          "Dr. $displayName",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
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

              // Drawer Items
              _drawerRow(Icons.person, "Profile", babyBlue),
              _divider(),
              _drawerRow(Icons.language, "Language", babyBlue),
              _divider(),
              _drawerRow(Icons.notifications_rounded, "Notification", babyBlue),
              _divider(),
              _drawerRow(Icons.palette_sharp, "Color Theme", babyBlue),
              _divider(),
              _drawerRow(Icons.star_purple500_sharp, "Rate Us", babyBlue),
              _divider(),
              _drawerRow(Icons.people, "Share with a friend", babyBlue),
              _divider(),
              _drawerRow(Icons.login_outlined, "Logout", babyBlue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerRow(IconData icon, String text, Color babyBlue) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: babyBlue),
        ),
        const SizedBox(width: 18),
        DrawerItemDoc(text: text),
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Colors.white,
        thickness: 1,
      ),
    );
  }
}
