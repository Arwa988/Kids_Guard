import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/patient.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/animations/doctorlist_animation.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/animations/people_animation.dart';

class HomeTabDoctor extends StatelessWidget {
  static const String routname = "./doctor_home_screen";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/MotherBg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // 🔹 App bar icons
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.settings,
                          color: AppColors.kPrimaryColor,
                          size: 30, // ⬆️ increased size
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications,
                        color: AppColors.kPrimaryColor,
                        size: 30, // ⬆️ increased size
                      ),
                    ),
                  ],
                ),
              ),



              // 🔹 Doctor animation centered
              Center(
                child: Transform.scale(
                  scale: 1.3, // 1.0 = original size, 1.5 = 50% bigger
                  child: DoctorlistAnimation(),
                ),
              ),




              // 🔹 Body container
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: AppColors.HomeScreenBodybg,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Patient(
                                text: "Total Patient",
                                number: "10",
                                bgColor: AppColors.lightBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Patient(
                                text: "Unstable Patient",
                                number: "5",
                                bgColor: AppColors.heartRed,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔸 Patients in danger
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.heartRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 20,
                            right: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                "Patient in danger",
                                style: TextStyle(fontSize: 25),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "2",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(fontSize: 35),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.kTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔸 View patient list
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7C5DE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 20,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text(
                                    "View Patient List",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  const SizedBox(height: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.kTextColor,
                                  ),
                                ],
                              ),
                              PeopleAnimation(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
