import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Login_Screen/wedgit/custom_text_field.dart';
import 'package:kids_guard/presentation/screens/Choose_Doctor_Screen/choose_doctor.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';

class ChildDetailsScreen extends StatefulWidget {
  const ChildDetailsScreen({super.key});
  static const String routname = "/child_details";

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

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

  Future<void> _saveChildDetails() async {
    try {
      setState(() => _isLoading = true);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final firestore = FirebaseFirestore.instance;

      // Save child details and get the generated document ID
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

      // Save phone number in "guardian" collection
      await firestore.collection('guardian').doc(user.uid).set({
        'userId': user.uid,
        'phone': phoneC.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Child and guardian details saved successfully')),
      );

      // Navigate to ChooseDoctorScreen with childId
      Navigator.pushNamed(
        context,
        ChooseDoctorScreen.routname,
        arguments: {'childId': docRef.id}, // ✅ pass childId here
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                        const Text(
                          "Your Child's Details",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: nameC,
                          hintText: 'Name',
                          validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Enter full name'
                              : null,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: phoneC,
                                hintText: 'Phone No.',
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Enter phone number';
                                  }
                                  if (!RegExp(r'^\d+$').hasMatch(v)) {
                                    return 'Only numbers';
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
                                    initialDate: DateTime(2020, 1, 1),
                                    firstDate: DateTime(2005),
                                    lastDate: DateTime.now(),
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
                                    hintText: 'Birth Date',
                                    validator: (v) => (v == null ||
                                        v.trim().isEmpty)
                                        ? 'Enter birth date'
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: addressC,
                          hintText: 'Address',
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                decoration: InputDecoration(
                                  hintText: 'Gender',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'Male',
                                      child: Text('Male',
                                          style: TextStyle(color: Colors.black))),
                                  DropdownMenuItem(
                                      value: 'Female',
                                      child: Text('Female',
                                          style: TextStyle(color: Colors.black))),
                                ],
                                onChanged: (v) =>
                                    setState(() => selectedGender = v),
                                validator: (v) =>
                                v == null ? 'Select gender' : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                controller: weightC,
                                hintText: 'Weight',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedSurgery,
                          decoration: InputDecoration(
                            hintText: 'Surgery',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Yes', child: Text('Yes', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'No', child: Text('No', style: TextStyle(color: Colors.black))),
                          ],
                          onChanged: (v) => setState(() => selectedSurgery = v),
                          validator: (v) => v == null ? 'Select surgery' : null,
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedAllergy,
                          decoration: InputDecoration(
                            hintText: 'Allergy',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'None', child: Text('None', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'I Don\'t Know', child: Text('I Don\'t Know', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'Drug Allergies', child: Text('Drug Allergies', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'Food Allergies', child: Text('Food Allergies', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'Environmental Allergies', child: Text('Environmental Allergies', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'Insect Allergies', child: Text('Insect Allergies', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'Other', child: Text('Other', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'More Than 1 Type of Allergies', child: Text('More Than 1 Type of Allergies', style: TextStyle(color: Colors.black))),
                          ],
                          onChanged: (v) => setState(() => selectedAllergy = v),
                          validator: (v) => v == null ? 'Select allergy' : null,
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedDiseaseType,
                          decoration: InputDecoration(
                            hintText: 'Select Disease Type',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Cardiac Arrhythmia', child: Text('Cardiac Arrhythmia', style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(value: 'Cyanotic Congenital', child: Text('Cyanotic Congenital', style: TextStyle(color: Colors.black))),
                          ],
                          onChanged: (v) => setState(() => selectedDiseaseType = v),
                          validator: (v) => v == null ? 'Select disease type' : null,
                        ),
                        const SizedBox(height: 10),
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
                                  : const Text(
                                'Next',
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
