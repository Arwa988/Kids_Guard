import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/drawer_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerDesgin extends StatelessWidget {
  const DrawerDesgin({super.key});

  // Fetch child or guardian name from Firebase
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Unknown User";

    final firestore = FirebaseFirestore.instance;

    // Check 'children' collection first
    final childQuery = await firestore
        .collection('children')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (childQuery.docs.isNotEmpty) {
      final childData = childQuery.docs.first.data();
      if (childData['name'] != null) {
        return childData['name'];
      }
    }

    // Check 'guardian' collection
    final guardianDoc =
    await firestore.collection('guardian').doc(user.uid).get();
    if (guardianDoc.exists && guardianDoc.data()?['username'] != null) {
      return guardianDoc['username'];
    }

    // Default fallback
    return "Unknown User";
  }

  @override
  Widget build(BuildContext context) {
    const Color babyBlue = Color(0xFFB4CEFF);

    return Drawer(
      child: Container(
        // ❌ Removed 'const' to avoid constant expression error with LinearGradient
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB4CEFF), // baby blue
              Color(0xFFB4CEFF), // soft blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Dynamic username display
              FutureBuilder<String>(
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

                  return Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/images/hana.png"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          displayName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // white text
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 50),

              // Drawer items
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

  // Helper method for Drawer row
  Widget _drawerRow(IconData icon, String text, Color babyBlue) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white, // white circle
          child: Icon(icon, color: babyBlue), // baby blue icon
        ),
        const SizedBox(width: 18),
        DrawerItem(
          text: text,

        ),
      ],
    );
  }

  // Helper for divider and spacing
  Widget _divider() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(
          color: Colors.white, // white line
          thickness: 1,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
