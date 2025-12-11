import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/DashBoard_patient.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/Health_metric.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/health_box.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/home_detector.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/heart_animation.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/home_app_bar_animation.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/chatbot/chatbot.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/Messaging/messaging.dart';

class HomeScreenTab extends StatelessWidget {
  static const String routname = "./home_screen";

  const HomeScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Top app bar icons
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(
                        Icons.settings,
                        color: AppColors.kPrimaryColor,
                        size: 33,
                      ),
                    ),
                  ),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.notifications,
                      color: AppColors.kPrimaryColor,
                      size: 33,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //  Child health summary box
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
                      width: 110,
                      height: 110,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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

            //  Three main feature boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  Ask The AI Guide
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
                        DetectorAnimation: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: SizedBox(
                            width: 65,
                            height: 65,
                            child: HomeAppBarAnimation(
                              lottiePath:
                                  "assets/lottie/Cloudroboticsabstract.json",
                            ),
                          ),
                        ),
                        text: "Ask The AI Guide",
                      ),
                    ),
                  ),
                ),

                //  Ask The Doctor
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DoctorScreen(),
                          ),
                        );
                      },
                      child: HomeDetector(
                        DetectorAnimation: const Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Image(
                            image: AssetImage("assets/images/diagnosis.png"),
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                        text: "Ask The Doctor",
                      ),
                    ),
                  ),
                ),
                //  Child Location
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: HomeDetector(
                      DetectorAnimation: HomeAppBarAnimation(
                        lottiePath: "assets/lottie/LocationPin.json",
                      ),
                      text: "Child Location",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            //  Health metrics section
            HealthMetric(),
          ],
        ),
      ),
    );
  }
}
