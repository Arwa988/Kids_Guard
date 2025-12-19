import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens/Choose_Doctor_Screen/choose_doctor.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';

class ChildDetailsScreen extends StatefulWidget {
  const ChildDetailsScreen({super.key});
  static const String routname = "/child_details";

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

// Backend of Child Details
class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final birthC = TextEditingController();
  final weightC = TextEditingController();
  final addressC = TextEditingController();

  String? selectedGender;
  String? selectedSurgery;
  String? selectedAllergy;
  String? selectedDiseaseType;

  bool _isLoading = false;

  // Save child + guardian data to Firestore
  Future<void> _saveChildDetails() async {
    try {
      setState(() => _isLoading = true);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }

      final firestore = FirebaseFirestore.instance;

      // Save child details in the "children" collection
      final docRef = await firestore.collection('children').add({
        'userId': user.uid,
        'name': nameC.text.trim(),
        'birthDate': birthC.text.trim(),
        'address': addressC.text.trim(),
        'gender': selectedGender,
        'weight': weightC.text.trim(),
        'surgery': selectedSurgery,
        'allergy': selectedAllergy,
        'diseaseType': selectedDiseaseType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Merge guardian info (email + phone) instead of overwriting
      await firestore.collection('guardian').doc(user.uid).set({
        'userId': user.uid,
        'email': user.email,
        'phone': phoneC.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Navigate to ChooseDoctorScreen with childId
      Navigator.pushNamed(
        context,
        ChooseDoctorScreen.routname,
        arguments: {'childId': docRef.id},
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // UI Child Details
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              const CloudDesgin(),
              Transform.translate(
                offset: const Offset(0, -130),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.child_details,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),

                        // Child Name
                        CustomTextField(
                          controller: nameC,
                          hintText: AppLocalizations.of(context)!.name,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? AppLocalizations.of(context)!.enter_name
                              : null,
                        ),
                        const SizedBox(height: 4),

                        // Phone and Birth Date
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: phoneC,
                                hintText: AppLocalizations.of(context)!.phone,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return AppLocalizations.of(context)!.phone;
                                  }
                                  if (!RegExp(r'^\d{11}$').hasMatch(v)) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.phone_rule;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2015, 1, 1),
                                    firstDate: DateTime(2010, 1, 1),
                                    lastDate: DateTime(2025, 12, 31),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      birthC.text =
                                          "${picked.day}/${picked.month}/${picked.year}";
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: CustomTextField(
                                    controller: birthC,
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.birth_date,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? AppLocalizations.of(
                                            context,
                                          )!.enter_birth
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Address
                        CustomTextField(
                          controller: addressC,
                          hintText: AppLocalizations.of(context)!.address,
                        ),
                        const SizedBox(height: 4),

                        // Gender and Weight
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.gender,
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
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: AppLocalizations.of(context)!.female,
                                    child: Text(
                                      AppLocalizations.of(context)!.female,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => selectedGender = v),
                                validator: (v) => v == null
                                    ? AppLocalizations.of(
                                        context,
                                      )!.select_gender
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: CustomTextField(
                                controller: weightC,
                                hintText: AppLocalizations.of(context)!.weight,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Surgery
                        DropdownButtonFormField<String>(
                          value: selectedSurgery,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.surgery,
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
                              value: AppLocalizations.of(context)!.yes,
                              child: Text(
                                AppLocalizations.of(context)!.yes,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.no,
                              child: Text(
                                AppLocalizations.of(context)!.no,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => selectedSurgery = v),
                          validator: (v) => v == null
                              ? AppLocalizations.of(context)!.select_surg
                              : null,
                        ),
                        const SizedBox(height: 5),

                        // Allergy
                        DropdownButtonFormField<String>(
                          value: selectedAllergy,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.allergy,
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
                              value: AppLocalizations.of(context)!.none,
                              child: Text(
                                AppLocalizations.of(context)!.none,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.donot_know,
                              child: Text(
                                AppLocalizations.of(context)!.donot_know,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.drug_allergy,
                              child: Text(
                                AppLocalizations.of(context)!.drug_allergy,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.food_allergy,
                              child: Text(
                                AppLocalizations.of(context)!.food_allergy,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(
                                context,
                              )!.enviro_allergy,
                              child: Text(
                                AppLocalizations.of(context)!.enviro_allergy,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(
                                context,
                              )!.insect_allergy,
                              child: Text(
                                AppLocalizations.of(context)!.insect_allergy,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.other,
                              child: Text(
                                AppLocalizations.of(context)!.other,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.more_type,
                              child: Text(
                                AppLocalizations.of(context)!.more_type,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => selectedAllergy = v),
                          validator: (v) => v == null
                              ? AppLocalizations.of(context)!.select_allergy
                              : null,
                        ),
                        const SizedBox(height: 4),

                        // Disease Type
                        DropdownButtonFormField<String>(
                          value: selectedDiseaseType,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            )!.select_disease,
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
                              value: AppLocalizations.of(context)!.cardiac,
                              child: Text(
                                AppLocalizations.of(context)!.cardiac,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.cyanotic,
                              child: Text(
                                AppLocalizations.of(context)!.cyanotic,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedDiseaseType = v),
                          validator: (v) => v == null
                              ? AppLocalizations.of(context)!.select_disease
                              : null,
                        ),
                        const SizedBox(height: 5),

                        // Next Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 120,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _saveChildDetails();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
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
                                        fontSize: 16,
                                        fontFamily: "Lexend",
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
