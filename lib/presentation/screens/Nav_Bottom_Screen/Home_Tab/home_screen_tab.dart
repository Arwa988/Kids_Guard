import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/health_box.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/home_detector.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/heart_animation.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/home_app_bar_animation.dart';

class HomeScreenTab extends StatelessWidget {
  static const String routname = "./home_screen";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔽 Top Row of Icons
              Row(
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
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🔽 Health Overview Card
              Center(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/images/happyheart.png"),
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Child Overall Health",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                            Text(
                              "Great!",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔽 3 Options Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeDetector(
                    DetectorAnimation: HomeAppBarAnimation(
                      LottiePath: "assets/lottie/Cloudroboticsabstract.json",
                    ),
                    text: "Ask The AI Guide",
                  ),
                  const SizedBox(width: 8),
                  HomeDetector(
                    DetectorAnimation: HomeAppBarAnimation(
                      LottiePath: "assets/lottie/doctor.json",
                    ),
                    text: "Ask The Doctor",
                  ),
                  const SizedBox(width: 8),
                  HomeDetector(
                    DetectorAnimation: HomeAppBarAnimation(
                      LottiePath: "assets/lottie/LocationPin.json",
                    ),
                    text: "Child Location",
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔽 Health Data Container
              Container(
                width: 500,
                height: 340,
                decoration: BoxDecoration(
                  color: AppColors.HomeScreenBodybg,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔹 Heart Beats Section
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Text("Heart Beats"),
                                Row(
                                  children: [
                                    Text(
                                      "89 ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(fontSize: 50),
                                    ),
                                    const Text("bpm"),
                                  ],
                                ),
                              ],
                            ),
                            HeartAnimation(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Blood Data
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 175,
                          height: 120,
                          child: HealthBox(
                            boxColor: AppColors.heartRed,
                            perenctage: "100/75",
                            symbol: "mmHg",
                            text: "Blood Pressure",
                          ),
                        ),
                        SizedBox(
                          width: 175,
                          height: 120,
                          child: HealthBox(
                            boxColor: AppColors.HomeScreenBg,
                            perenctage: "95%",
                            symbol: "SPO2",
                            text: "Blood Oxygen",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
