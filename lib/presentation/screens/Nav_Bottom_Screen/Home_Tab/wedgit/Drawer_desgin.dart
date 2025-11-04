import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/drawer_item.dart';

class DrawerDesgin extends StatelessWidget {
  const DrawerDesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: AppColors.kLightBlue),

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
                  Text(
                    "Hana Walid",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kTextColor,
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
                    foregroundColor: Color(Colors.blueAccent.value),
                 
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Profile"),
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
                    foregroundColor: Color(Colors.blueAccent.value),
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Language"),
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
                    foregroundColor: Color(Colors.blueAccent.value),
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Notification"),
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
                    foregroundColor: Color(Colors.blueAccent.value),
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Color Theme"),
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
                    foregroundColor: Color(Colors.blueAccent.value),
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Rate Us"),
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
                    foregroundColor: Color(Colors.blueAccent.value),
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Share with a friend"),
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
                    foregroundColor: Color(Colors.blueAccent.value),
                  ),
                  SizedBox(width: 24),
                  DrawerItem(text: "Logout"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
