import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens_doctor/Profile_Photo_Screen/profile_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
  static const String routname = "/create_account";
}
// Create Account Backend
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
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }
// Save data in the doctors collection
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('Doctors').doc(user.uid).set({
        'userId': user.uid,
        'firstname': firstC.text.trim(),
        'lastname': lastC.text.trim(),
        'gender': selectedGender,
        'phone_number': phoneC.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor details saved successfully')),
      );

      Navigator.pushNamed(context, ProfilePhotoScreen.routname);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
// Create Account UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CloudDesgin(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              ),
              Text(
                'Create Account',
                style: TextStyle(
                  fontFamily: "Lexend",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextColor,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: firstC,
                        hintText: 'First Name',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter first name'
                            : null,
                      ),
                      CustomTextField(
                        controller: lastC,
                        hintText: 'Last Name',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter last name'
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          decoration: InputDecoration(
                            hintText: 'Gender',
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male', style: TextStyle(color: AppColors.kTextColor)),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female', style: TextStyle(color: AppColors.kTextColor)),
                            ),
                          ],
                          onChanged: (v) => setState(() => selectedGender = v),
                          validator: (v) => v == null ? 'Select gender' : null,
                        ),
                      ),
                      CustomTextField(
                        controller: phoneC,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter phone';
                          if (!RegExp(r'^\d+$').hasMatch(v)) return 'Only numbers';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                if (_formKey.currentState!.validate()) {
                                  await _saveDoctorDetails(); // send data to firestore
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
