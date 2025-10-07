import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/next_btn.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/animations/real_time_animation.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/emergency_alerts_doctor_screen.dart';

class RealTimeDoctor extends StatelessWidget {
  static const String routname = "/real_time_doctor";

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
            child: RealTimeAnimation(),
          ),
          SizedBox(height: 10),
          Text(
            "Real-Time Monitoring",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 5),
          Text(
            "Real time data access! View live heart rate, \n oxygen level, blood pressure",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 10),
          NextBtn(routname: EmergencyAlertsDoctor.routname, text: "Next"),
          SizedBox(height: 10),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 100),
                Image(
                  image: AssetImage("assets/images/ProgressIndicator5.png"),
                ),
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
          ),
        ],
      ),
    );
  }
}
