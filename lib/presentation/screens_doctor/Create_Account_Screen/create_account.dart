import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens_doctor/Profile_Photo_Screen/profile_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});
  static const String routname = "/create_account";

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}
// Backend of create account
class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstC = TextEditingController();
  final lastC = TextEditingController();
  final phoneC = TextEditingController();
  String? selectedGender;
  bool _isLoading = false;

  Future<void> _saveDoctorDetails() async {
    try {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in')));
        return;
      }

      await FirebaseFirestore.instance.collection('doctors').doc(user.uid).update({
        'firstName': firstC.text.trim(),
        'lastName': lastC.text.trim(),
        'gender': selectedGender,
        'phoneNumber': phoneC.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doctor details saved successfully')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfilePhotoScreen(userType: "doctor"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
// UI of create account
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CloudDesgin(),
              const SizedBox(height: 20),
              const Text(
                'Create Account',
                style: TextStyle(
                    fontFamily: "Lexend",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextColor),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: firstC,
                        hintText: 'First Name',
                        validator: (v) =>
                        v!.isEmpty ? 'Enter first name' : null,
                      ),
                      CustomTextField(
                        controller: lastC,
                        hintText: 'Last Name',
                        validator: (v) => v!.isEmpty ? 'Enter last name' : null,
                      ),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        hintText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text(
                            'Male',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text(
                            'Female',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => selectedGender = v),
                      validator: (v) => v == null ? 'Select gender' : null,
                      style: const TextStyle(color: Colors.black), //
                    ),

                    const SizedBox(height: 10),
                      CustomTextField(
                        controller: phoneC,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                        v!.isEmpty ? 'Enter phone number' : null,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              _saveDoctorDetails();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            minimumSize: const Size(100, 44),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text('Next',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
