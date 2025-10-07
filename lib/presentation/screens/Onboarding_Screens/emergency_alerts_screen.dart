import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/easy_setup_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/emergency_animation.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/next_btn.dart';

class EmergencyAlerts extends StatelessWidget {
  const EmergencyAlerts({super.key});
  static const String routname = "/emergency";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),

          Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/blueblob.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: EmergencyAnimation(),
          ),
          SizedBox(height: 8),
          Text(
            "Emergency Alerts",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 5),
          Text(
            "Got Notified Instantly! if something goes \nwrong, you and your doctor will be alerted right away",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          NextBtn(routname: EasySetupScreen.routname, text: "Next"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 100),
              Image(image: AssetImage("assets/images/ProgressIndicator2.png")),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Create account",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
