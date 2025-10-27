import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/home_screen.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/home_screen_doctor.dart';

class ProfilePhotoScreen extends StatelessWidget {
  final String userType; // "guardian" or "doctor"
  const ProfilePhotoScreen({super.key, required this.userType});
  static const String routname = "/add_photo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloudDesgin(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 3),
                            color: Colors.grey,
                          ),
                        ],
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/person.png",
                            width: 80, height: 80),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      bottom: -8,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: implement photo picker
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  "Add a profile photo",
                  style: TextStyle(
                    fontFamily: "Lexend",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextColor,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () {
                  if (userType == "doctor") {
                    Navigator.pushReplacementNamed(
                        context, HomeScreenDoctor.routname);
                  } else {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routname);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontFamily: "Lexend",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
