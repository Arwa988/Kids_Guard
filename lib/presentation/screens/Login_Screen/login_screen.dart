import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/Guardin_Screen.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens/Sign_Up_Screen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routname = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
//Login Backend
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  bool _hoverRegister = false;

  // Regular Email Login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passwordC.text,
        );

        Navigator.pushReplacementNamed(context, '/home_screen');
      } on FirebaseAuthException catch (e) {
        String message = '';
        // problem Cases
        if (e.code == 'user-not-found') {
          message = 'No account found for this email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = 'Login failed. Please check your email and password.';
        }
        _showError(message);
      } catch (e) {
        _showError('Error: $e');
      }
    }
  }

  // SnackBar messages
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  //  Google Sign-In (Android Only)
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
        '50621609901-daui7cd621mnelnrpuegvh3iot1e2jfl.apps.googleusercontent.com',
      );

      // Always show account chooser
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

  //  Wrapper for Google Login
  Future<void> _loginWithGoogle() async {
    final userCredential = await _signInWithGoogle();
    if (userCredential == null) return;

    final user = userCredential.user;
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully with Google 🎉')),
      );
      Navigator.pushReplacementNamed(context, '/home_screen'); //go to home page
    }
  }

  // Reset Password
  Future<void> _resetPassword() async {
    if (emailC.text.trim().isEmpty) {
      _showError('Please enter your email first.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailC.text.trim(),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset Email Sent'),
          content: const Text(
            'A reset link has been sent to your email. Please check your inbox to reset your password.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No account found for this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      } else {
        message = 'Failed to send reset email. Try again later.';
      }
      _showError(message);
    } catch (e) {
      _showError('Error: $e');
    }
  }

  // Login UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 28.0, vertical: 48.0),
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
                    const SizedBox(height: 6),

                    Center(
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: const Text(
                          'Forgot password? Reset your password',
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

                    // ✅ Email Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _login,// on press: submit data to firebase
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Login',
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

                    // ✅ Google Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _loginWithGoogle,// onclick: submit data to firebase
                        icon: Image.asset(
                          'assets/images/google.png',
                          height: 20,
                        ),
                        label: const Text(
                          'Signin with Google',
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

                    const SizedBox(height: 20),

                    MouseRegion(
                      onEnter: (_) => setState(() => _hoverRegister = true),
                      onExit: (_) => setState(() => _hoverRegister = false),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            SignUpScreen.routname,
                          );
                          if (result != null && result is Map) {
                            emailC.text = result['email'] ?? '';
                            passwordC.text = result['password'] ?? '';
                          }
                        },
                        child: Text(
                          "Don't have an account? Sign Up",
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
