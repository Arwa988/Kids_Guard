import 'package:flutter/material.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/next_btn.dart';
import 'package:kids_guard/presentation/screens_doctor/Create_Account_Screen/create_account.dart';
import 'package:kids_guard/presentation/screens_doctor/Login_doctor_screen/login_doctor.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/animations/emergency_animation.dart';

class EmergencyAlertsDoctor extends StatelessWidget {
  static const String routname = "/emergency_doctor";

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
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginScreenDoctor.routname);
                },
                child: Text(
                  AppLocalizations.of(context)!.skip,
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
                image: AssetImage("assets/images/pinkblob.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: EmergencyAnimationDoctor(),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.emergency_alert,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              AppLocalizations.of(context)!.emergency_desc,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          NextBtn(
            routname: LoginScreenDoctor.routname,
            text: AppLocalizations.of(context)!.next,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 100),
              Image(image: AssetImage("assets/images/ProgressIndicator4.png")),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                child: TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(CreateAccountScreen.routname);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.create_account,
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
