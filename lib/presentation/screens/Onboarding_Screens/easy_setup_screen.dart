import 'package:flutter/material.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/login_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/fitness_animation.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/mobile_animation.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/next_btn.dart';

class EasySetupScreen extends StatelessWidget {
  const EasySetupScreen({super.key});
  static const String routname = "/easy_setup";
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
                  Navigator.of(context).pushNamed(LoginScreen.routname);
                },
                child: Text(
                  AppLocalizations.of(context)!.skip,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),

          Stack(
            children: [
              Container(
                width: 450,
                height: 450,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/pinkblob.png"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: FitnessAnimation(),
              ),
              MobileAnimation(),
            ],
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.easy_setup,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              AppLocalizations.of(context)!.easy_desc,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          NextBtn(
            routname: LoginScreen.routname,
            text: AppLocalizations.of(context)!.next,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 100),
              Image(image: AssetImage("assets/images/ProgressIndicator3.png")),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                child: TextButton(
                  onPressed: () {},
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
