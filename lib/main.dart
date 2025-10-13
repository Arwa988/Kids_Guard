import 'package:flutter/material.dart';

import 'package:kids_guard/core/theme/App_Theme.dart';
import 'package:kids_guard/presentation/screens_doctor/Create_Account_Screen/create_account.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/Guardin_Screen.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/login_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/easy_setup_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/emergency_alerts_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/real_time_monitoring_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/welcome_screen.dart';
import 'package:kids_guard/presentation/screens/Sign_Up_Screen/sign_up_screen.dart';
import 'package:kids_guard/presentation/screens/Splash_Screen/splash_screen.dart';
import 'package:kids_guard/presentation/screens/Languge_Screen/languge_screen.dart';
import 'package:kids_guard/presentation/screens_doctor/Login_doctor_screen/login_doctor.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/emergency_alerts_doctor_screen.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/real_time_monitoring_doctor_screen.dart';
import 'package:kids_guard/presentation/screens_doctor/Profile_Photo_Screen/profile_photo.dart';
import 'package:kids_guard/presentation/screens_doctor/Sign_doctor_screen/sign_up_doctor.dart';
import 'package:kids_guard/presentation/screens/Child_Details_Screen/child_details.dart';
import 'package:kids_guard/presentation/screens/Choose_Doctor_Screen/choose_doctor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LangugeScreen.routname: (context) => LangugeScreen(),
        // ignore: equal_keys_in_map
        WelcomeScreen.routname: (context) => WelcomeScreen(),
        RealTime.routname: (context) => RealTime(),
        EmergencyAlerts.routname: (context) => EmergencyAlerts(),
        EasySetupScreen.routname: (context) => EasySetupScreen(),
        LoginScreen.routname: (context) => LoginScreen(),
        SignUpScreen.routname: (context) => SignUpScreen(),
        GuardinScreen.routname: (context) => GuardinScreen(),
        EmergencyAlertsDoctor.routname: (context) => EmergencyAlertsDoctor(),
        // ignore: equal_keys_in_map
        RealTimeDoctor.routname: (context) => RealTimeDoctor(),
        LoginScreenDoctor.routname: (context) => LoginScreenDoctor(),
        SignUpScreenDoctor.routname: (context) => SignUpScreenDoctor(),
        CreateAccountScreen.routname: (context) => CreateAccountScreen(),
        ProfilePhotoScreen.routname: (context) => ProfilePhotoScreen(),
        ChildDetailsScreen.routname: (context) =>  ChildDetailsScreen(),
        ChooseDoctorScreen.routname:(context) => ChooseDoctorScreen()
      },
      theme: AppTheme.lighttheme,
    );
  }
}
