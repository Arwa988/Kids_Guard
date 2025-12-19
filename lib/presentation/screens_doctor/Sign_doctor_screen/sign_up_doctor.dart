import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/login_screen.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens_doctor/Create_Account_Screen/create_account.dart';
import 'package:kids_guard/presentation/screens_doctor/Login_doctor_screen/login_doctor.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});
  static const String routname = "/doctor_signup_screen";

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

// Signup Backend
class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();
  bool _hoverLogin = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailC.text.trim(),
            password: passwordC.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) return;

      //  Save in `users` collection
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': emailC.text.trim(),
        'uid': user.uid,
        'role': 'doctor',
        'createdAt': Timestamp.now(),
      });

      // Send email verification if needed
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      //  Navigate to CreateAccountScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Signup failed");
    }
  }

  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '50621609901-daui7cd621mnelnrpuegvh3iot1e2jfl.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );

      final user = userCredential.user;
      if (user == null) return;

      // Save in `users` collection
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
        'role': 'doctor',
        'createdAt': Timestamp.now(),
      });

      // Navigate to CreateAccountScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
      );
    } catch (e) {
      _showError("Google Sign-Up failed: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Signup UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Column(
            children: [
              Image.asset(
                'assets/images/kidsguard.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 36),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailC,
                      hintText: AppLocalizations.of(context)!.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return AppLocalizations.of(context)!.enter_email;
                        if (!v.contains('@'))
                          return AppLocalizations.of(context)!.invalid_email;
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: passwordC,
                      hintText: AppLocalizations.of(context)!.password,
                      isPassword: true,
                      validator: (v) => v!.length < 6
                          ? AppLocalizations.of(context)!.return_six
                          : null,
                    ),
                    CustomTextField(
                      controller: confirmC,
                      hintText: AppLocalizations.of(context)!.conf_pass,
                      isPassword: true,
                      validator: (v) => v != passwordC.text
                          ? AppLocalizations.of(context)!.pass_match
                          : null,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimaryColor,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _signUpWithGoogle,
                      icon: Image.asset('assets/images/google.png', height: 20),
                      label: Text(AppLocalizations.of(context)!.sigup_google),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        LoginScreenDoctor.routname,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.have_account,
                        style: TextStyle(
                          color: _hoverLogin
                              ? AppColors.kPrimaryColor
                              : AppColors.kTextColor,
                        ),
                      ),
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
