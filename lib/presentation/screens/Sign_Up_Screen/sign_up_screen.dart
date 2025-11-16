import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/login_screen.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routname = "/signup_screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// Signup Backend
class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();
  bool _hoverLogin = false;

  late String userRole;

  // Set Guardian/Doctor Signup role
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    userRole = args?['role'] ?? 'guardian';
  }

  // Email Sign-Up (Create Account)
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passwordC.text.trim(),
        );

        final user = userCredential.user;
        if (user == null) return;

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': emailC.text.trim(),
          'role': userRole,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created successfully 🎉. Please verify your email.',
            ),
          ),
        );

        // Redirect based on role
        if (userRole == 'guardian') {
          Navigator.pushReplacementNamed(context, '/child_details');
        } else if (userRole == 'doctor') {
          Navigator.pushReplacementNamed(context, '/create_account');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showError('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showError('The account already exists for that email.');
        }
      } catch (e) {
        _showError('Error: $e');
      }
    }
  }

  // Show snackbar error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Google Sign-In (Android only)
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
        '50621609901-daui7cd621mnelnrpuegvh3iot1e2jfl.apps.googleusercontent.com',
      );

      // Force account chooser each time
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      _showError("Google sign-in failed: $e");
      return null;
    }
  }

  // Google Sign-Up
  Future<void> _signUpWithGoogle() async {
    try {
      final userCredential = await _signInWithGoogle();
      if (userCredential == null) return;

      final user = userCredential.user;
      if (user == null) return;

      final userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();

      // Create user doc if not exists
      if (!snapshot.exists) {
        await userDoc.set({
          'userId': user.uid,
          'email': user.email,
          'role': userRole,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed up successfully with Google 🎉')),
      );

      if (userRole == 'guardian') {
        Navigator.pushReplacementNamed(context, '/child_details');
      } else if (userRole == 'doctor') {
        Navigator.pushReplacementNamed(context, '/create_account');
      }
    } catch (e) {
      _showError("Google Sign-Up failed: $e");
    }
  }

  // Sign up UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 28.0, vertical: 48.0),
          child: Column(
            children: [
              // Logo
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
                        if (v == null || v.length < 6) {
                          return 'At least 6 characters';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: confirmC,
                      hintText: 'Confirm Password',
                      isPassword: true,
                      validator: (v) =>
                      v != passwordC.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 18),

                    // Regular sign-up button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: "Lexend",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Google Sign-Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _signUpWithGoogle,
                        icon: Image.asset(
                          'assets/images/google.png',
                          height: 20,
                        ),
                        label: const Text(
                          'Sign up with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Lexend",
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    MouseRegion(
                      onEnter: (_) => setState(() => _hoverLogin = true),
                      onExit: (_) => setState(() => _hoverLogin = false),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          LoginScreen.routname,
                        ),
                        child: Text(
                          'Already have an account? Log In',
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
