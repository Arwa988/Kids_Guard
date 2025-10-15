import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChooseDoctorScreen extends StatefulWidget {
  const ChooseDoctorScreen({super.key});
  static const String routname = "/choose_doctor";

  @override
  State<ChooseDoctorScreen> createState() => _ChooseDoctorScreenState();
}
// Choose Doctor Backend
class _ChooseDoctorScreenState extends State<ChooseDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDoctor;
  late String childId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    childId = args?['childId'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CloudDesgin(),
              Transform.translate(
                offset: const Offset(0, -100),
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
                      children: [
                        const Text(
                          'Choose A Doctor',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kTextColor,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          children: [
                            _buildDoctorOption(
                                'Dr. Sara Mahmoud', 'assets/images/pfp.png'),
                            _buildDoctorOption(
                                'Dr. Ahmed El-Sayed', 'assets/images/pfp.png'),
                            _buildDoctorOption(
                                'Dr. Leila Hassan', 'assets/images/pfp.png'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              height: 44,
                              // add the choosed doctor in the child document
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (childId.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Child ID is invalid!')));
                                    return;
                                  }

                                  if (_formKey.currentState!.validate() &&
                                      selectedDoctor != null) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('children')
                                          .doc(childId)
                                          .update({'doctor': selectedDoctor});

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Doctor selected successfully!')));

                                      Navigator.pushNamed(
                                          context, '/add_photo');
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text('Error: $e')));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Please select a doctor first!')));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
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

  Widget _buildDoctorOption(String name, String imagePath) {
    final bool isSelected = selectedDoctor == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDoctor = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryBlue.withAlpha(38),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primaryBlue : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Colors.purpleAccent, size: 24),
          ],
        ),
      ),
    );
  }
}
