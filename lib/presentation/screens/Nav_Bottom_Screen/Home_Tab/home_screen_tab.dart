import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:lottie/lottie.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/health_box.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/home_detector.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/heart_animation.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/home_app_bar_animation.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/chatbot.dart';

class HomeScreenTab extends StatelessWidget {
  static const String routname = "./home_screen";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 AppBar icons
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.settings,
                        color: AppColors.kPrimaryColor,
                        size: 33,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: AppColors.kPrimaryColor,
                      size: 33,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Health summary
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
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                          Text(
                            "Great!",
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
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

            // 🔹 3 main boxes (Ask AI, Ask Doctor, Child Location)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Ask The AI Guide
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChatbotScreen(),
                          ),
                        );
                      },
                      child: HomeDetector(
                        DetectorAnimation: SizedBox(
                          width: 60,
                          height: 60,
                          child: Lottie.asset(
                            "assets/lottie/Cloudroboticsabstract.json",
                            fit: BoxFit.contain,
                          ),
                        ),
                        text: "Ask The AI Guide",
                      ),
                    ),
                  ),
                ),

                // ✅ Ask The Doctor
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: HomeDetector(
                      DetectorAnimation: HomeAppBarAnimation(
                        LottiePath: "assets/lottie/doctor.json",
                      ),
                      text: "Ask The Doctor",
                    ),
                  ),
                ),

                // ✅ Child Location
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: HomeDetector(
                      DetectorAnimation: HomeAppBarAnimation(
                        LottiePath: "assets/lottie/LocationPin.json",
                      ),
                      text: "Child Location",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔹 Health Data Boxes
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
    );
  }
}
