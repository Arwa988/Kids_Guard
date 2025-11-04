import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/Guardin_Screen.dart';

class SignUpScreenDoctor extends StatefulWidget {
  static const String routname = "/sign_up_doctor";

  @override
  State<SignUpScreenDoctor> createState() => _SignUpScreenDoctorState();
}

class _SignUpScreenDoctorState extends State<SignUpScreenDoctor> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  bool _hoverLogin = false;

  // Email/Password signup
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passwordC.text.trim(),
        );

        Navigator.pushReplacementNamed(context, GuardinScreen.routname);
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'email-already-in-use') {
          message = 'This email is already registered.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email format.';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak.';
        } else {
          message = 'Signup failed. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Google Sign-In (Android only, with account chooser)
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
        "50621609901-daui7cd621mnelnrpuegvh3iot1e2jfl.apps.googleusercontent.com",
      );

      await googleSignIn.signOut(); // =ƒæê Forces account picker
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacementNamed(context, GuardinScreen.routname);
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
      return null;
    }
  }

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
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter email';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: passwordC,
                      hintText: 'Password',
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.length < 6)
                          return 'At least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
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
                        label: const Text(
                          'Sign up with Google',
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
                      onEnter: (_) => setState(() => _hoverLogin = true),
                      onExit: (_) => setState(() => _hoverLogin = false),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: _hoverLogin
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
