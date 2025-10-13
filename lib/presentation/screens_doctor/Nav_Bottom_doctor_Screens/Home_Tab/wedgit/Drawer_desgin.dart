import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/drawer_item.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/Drawer_item_doc.dart';

class DrawerDesginDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.textPrimary, AppColors.textSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/hana.png"),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "Dr. Maha Ahmed",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Profile"),
                ],
              ),
              SizedBox(height: 16),
              Image(image: AssetImage("assets/images/Line.png")),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.language),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Language"),
                ],
              ),
              SizedBox(height: 16),
              Image(image: AssetImage("assets/images/Line.png")),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.notifications_rounded),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Notification"),
                ],
              ),
              SizedBox(height: 16),
              Image(image: AssetImage("assets/images/Line.png")),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.palette_sharp),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Color Theme"),
                ],
              ),
              SizedBox(height: 16),
              Image(image: AssetImage("assets/images/Line.png")),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.star_purple500_sharp),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Rate Us"),
                ],
              ),
              SizedBox(height: 16),
              Image(image: AssetImage("assets/images/Line.png")),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.people),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Share with a friend"),
                ],
              ),
              SizedBox(height: 16),
              Image(image: AssetImage("assets/images/Line.png")),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.login_outlined),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.kPrimaryColor,
                  ),
                  SizedBox(width: 24),
                  DrawerItemDoc(text: "Logout"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
