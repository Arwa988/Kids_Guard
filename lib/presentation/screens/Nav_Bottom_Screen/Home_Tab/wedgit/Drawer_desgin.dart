import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/drawer_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerDesgin extends StatelessWidget {
  const DrawerDesgin({super.key});

  //  Drawer Backend (fetch name from Firebase)
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Unknown User";

    final firestore = FirebaseFirestore.instance;

    // Try to find in 'children' collection first
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

    // If not found, try in 'guardian' collection
    final guardianDoc =
    await firestore.collection('guardian').doc(user.uid).get();
    if (guardianDoc.exists && guardianDoc.data()?['username'] != null) {
      return guardianDoc['username'];
    }

    // Default fallback
    return "Unknown User";
  }

  //  Drawer UI
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.pink,
              Color(Colors.pinkAccent.value).withOpacity(0.5),
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
               // Backend
              ///Show child or guardian name dynamically
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
                        radius: 30,
                        backgroundImage: AssetImage("assets/images/hana.png"),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          displayName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 220, 146, 146),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 50),

              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.person),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Profile"),
                ],
              ),
              const SizedBox(height: 16),
              const Image(image: AssetImage("assets/images/Line.png")),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.language),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Language"),
                ],
              ),
              const SizedBox(height: 16),
              const Image(image: AssetImage("assets/images/Line.png")),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.notifications_rounded),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Notification"),
                ],
              ),
              const SizedBox(height: 16),
              const Image(image: AssetImage("assets/images/Line.png")),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.palette_sharp),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Color Theme"),
                ],
              ),
              const SizedBox(height: 16),
              const Image(image: AssetImage("assets/images/Line.png")),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.star_purple500_sharp),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Rate Us"),
                ],
              ),
              const SizedBox(height: 16),
              const Image(image: AssetImage("assets/images/Line.png")),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.people),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Share with a friend"),
                ],
              ),
              const SizedBox(height: 16),
              const Image(image: AssetImage("assets/images/Line.png")),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.login_outlined),
                    backgroundColor: AppColors.pink,
                    foregroundColor: Color(Colors.pinkAccent.value),
                  ),
                  const SizedBox(width: 24),
                  const DrawerItem(text: "Logout"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
