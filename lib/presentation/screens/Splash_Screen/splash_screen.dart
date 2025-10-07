import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.2,
        height: MediaQuery.of(context).size.height * 1.1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.splashScreenLinearWhite,
              AppColors.splashScreenLinearBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset("assets/images/logo.png", width: 300, height: 300)
              .animate(
                onComplete: (v) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
              )
              .fadeIn(duration: Duration(milliseconds: 500))
              .fadeOut(
                delay: Duration(seconds: 2),
                duration: Duration(milliseconds: 500),
              ),
        ),
      ),
    );
  }
}
