import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens_doctor/Sign_doctor_screen/sign_up_doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/home_screen_doctor.dart';
import 'package:kids_guard/presentation/screens_doctor/Create_Account_Screen/create_account.dart';

class LoginScreenDoctor extends StatefulWidget {
  static const String routname = "/login_screen_doctor";

  @override
  State<LoginScreenDoctor> createState() => _LoginScreenDoctorState();
}

///Login Backend
class _LoginScreenDoctorState extends State<LoginScreenDoctor> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  bool _hoverRegister = false;

  /// Email/Password login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailC.text.trim(),
            password: passwordC.text,
          );

      final user = userCredential.user;
      if (user == null) return;

      // Check if doctor profile exists
      final docSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        Navigator.pushReplacementNamed(context, HomeScreenDoctor.routname);
      } else {
        Navigator.pushReplacementNamed(context, CreateAccountScreen.routname);
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No account found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Login failed. Please check your email and password.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Google Sign-In (Android only)
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "50621609901-daui7cd621mnelnrpuegvh3iot1e2jfl.apps.googleusercontent.com",
      );
      await googleSignIn.signOut(); // force account chooser

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user != null) {
        // Save basic user info
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': user.email,
          'role': 'doctor',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Check if doctor profile exists
        final docSnapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          Navigator.pushReplacementNamed(context, HomeScreenDoctor.routname);
        } else {
          Navigator.pushReplacementNamed(context, CreateAccountScreen.routname);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
    }
  }

  /// Password reset
  Future<void> _resetPassword() async {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.reset_password),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.email,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: emailController.text.trim(),
                  );
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.email_sent),
                      content: Text(AppLocalizations.of(context)!.reset_link),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.ok),
                        ),
                      ],
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  String message = '';
                  if (e.code == 'user-not-found') {
                    message = AppLocalizations.of(context)!.no_account;
                  } else if (e.code == 'invalid-email') {
                    message = AppLocalizations.of(context)!.invalid_email;
                  } else {
                    message = AppLocalizations.of(context)!.failed_email_send;
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
              child: Text(AppLocalizations.of(context)!.send),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  /// Login UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 48.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/kidsguard.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
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
                        if (v == null || v.trim().isEmpty)
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
                      validator: (v) {
                        if (v == null || v.length < 6)
                          return AppLocalizations.of(context)!.return_six;
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: Text(
                          AppLocalizations.of(context)!.forget_pass,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.kTextColor,
                            fontFamily: "Lexend",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: "Lexend",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: Image.asset(
                          'assets/images/google.png',
                          height: 24,
                          width: 24,
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.sign_google,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MouseRegion(
                      onEnter: (_) => setState(() => _hoverRegister = true),
                      onExit: (_) => setState(() => _hoverRegister = false),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            DoctorSignUpScreen.routname,
                          );
                          if (result != null && result is Map) {
                            emailC.text = result['email'] ?? '';
                            passwordC.text = result['password'] ?? '';
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.donot_have_account,
                          style: TextStyle(
                            color: _hoverRegister
                                ? AppColors.kPrimaryColor
                                : AppColors.kTextColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Lexend",
                          ),
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
