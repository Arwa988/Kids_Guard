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
          const CloudDesgin(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Circle container (unchanged)
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        boxShadow: const [
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
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 80,  // smaller width than circle
                          height: 80, // smaller height than circle
                          child: Image.asset(
                            "assets/images/person.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // "+" Icon at bottom-right
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Pick image from device or Firebase
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
,
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
