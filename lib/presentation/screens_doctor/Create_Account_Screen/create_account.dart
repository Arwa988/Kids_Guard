import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens_doctor/Profile_Photo_Screen/profile_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});
  static const String routname = "/create_account";
  // create account backend
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstC = TextEditingController();
  final lastC = TextEditingController();
  final phoneC = TextEditingController();
  String? selectedGender;
  bool _isLoading = false;

  /// Save doctor details in the doctors collection
  Future<void> _saveDoctorDetails() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }

      // Save doctor info in the "doctors" collection
      await FirebaseFirestore.instance.collection('doctors').doc(user.uid).set({
        'userId': user.uid,
        'firstname': firstC.text.trim(),
        'lastname': lastC.text.trim(),
        'gender': selectedGender,
        'phone_number': phoneC.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.doctor_details_saved),
        ),
      );

      // Navigate to ProfilePhotoScreen for doctor
      Navigator.pushReplacementNamed(
        context,
        ProfilePhotoScreen.routname,
        arguments: "doctor",
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    firstC.dispose();
    lastC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  // create account ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CloudDesgin(),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.create_account,
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
                        hintText: AppLocalizations.of(context)!.first_name,
                        validator: (v) => v!.isEmpty
                            ? AppLocalizations.of(context)!.first_name
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: lastC,
                        hintText: AppLocalizations.of(context)!.last_name,
                        validator: (v) => v!.isEmpty
                            ? AppLocalizations.of(context)!.last_name
                            : null,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.gender,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: AppLocalizations.of(context)!.male,
                            child: Text(
                              AppLocalizations.of(context)!.male,
                              style: TextStyle(color: AppColors.kTextColor),
                            ),
                          ),
                          DropdownMenuItem(
                            value: AppLocalizations.of(context)!.female,
                            child: Text(
                              AppLocalizations.of(context)!.female,
                              style: TextStyle(color: AppColors.kTextColor),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => selectedGender = v),
                        validator: (v) => v == null
                            ? AppLocalizations.of(context)!.select_gender
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: phoneC,
                        hintText: AppLocalizations.of(context)!.phone_number,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return AppLocalizations.of(context)!.enter_phone;
                          if (!RegExp(r'^\d+$').hasMatch(v))
                            return AppLocalizations.of(context)!.only_numbers;
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: 120,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveDoctorDetails,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!.next,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
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
