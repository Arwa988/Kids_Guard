import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/login_screen.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens_doctor/Create_Account_Screen/create_account.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});
  static const String routname = "/doctor_signup_screen";

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}
//Signup Backend
class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();
  bool _hoverLogin = false;

  // Email/Password signup
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passwordC.text.trim(),
        );

        final user = userCredential.user;
        if (user == null) return;

        await FirebaseFirestore.instance.collection('doctors').doc(user.uid).set({
          'email': emailC.text.trim(),
          'uid': user.uid,
          'role': 'doctor',
          'createdAt': Timestamp.now(),
        });

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
        );
      } on FirebaseAuthException catch (e) {
        _showError(e.message ?? "Signup failed");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Google Sign-Up
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
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );

      final user = userCredential.user;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('doctors').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
        'role': 'doctor',
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed up successfully with Google 🎉')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
      );
    } catch (e) {
      _showError("Google Sign-Up failed: $e");
    }
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
              Image.asset('assets/images/kidsguard.png',
                  height: 200, width: 200),
              const SizedBox(height: 36),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailC,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter email';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: passwordC,
                      hintText: 'Password',
                      isPassword: true,
                      validator: (v) =>
                      v!.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    CustomTextField(
                      controller: confirmC,
                      hintText: 'Confirm Password',
                      isPassword: true,
                      validator: (v) =>
                      v != passwordC.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimaryColor,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Sign up as Doctor',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _signUpWithGoogle,
                      icon: Image.asset('assets/images/google.png', height: 20),
                      label: const Text('Sign up with Google'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, LoginScreen.routname),
                      child: Text(
                        'Already have an account? Log In',
                        style: TextStyle(
                            color: _hoverLogin
                                ? AppColors.kPrimaryColor
                                : AppColors.kTextColor),
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
