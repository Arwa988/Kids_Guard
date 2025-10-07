import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';

class ProfilePhotoScreen extends StatelessWidget {
  const ProfilePhotoScreen({super.key});
  static const String routname = "/add_photo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CloudDesgin(),
          Stack(
            alignment: Alignment(0.3, -0.2),
            children: [
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment(0.1, -0.3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurStyle: BlurStyle.normal,
                              blurRadius: 7,
                              spreadRadius: 5,
                              offset: Offset(0, 3),
                              color: Colors.grey,
                            ),
                          ],
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage("assets/images/person.png"),
                          ),
                        ),
                        child: Padding(padding: const EdgeInsets.all(12.0)),
                      ),
                      const SizedBox(height: 25),

                      // Text below the circle
                      Text(
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
              ),

              Image(image: AssetImage("assets/images/Plus.png")),
            ],
          ),

          /// Bottom buttons area (Skip / Done)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kTextColor,
                      ),
                    ),
                  ),

                  // Done button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: const Size(91, 49),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
