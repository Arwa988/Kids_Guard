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
                                'Dr. Sara Mahmoud', 'assets/images/pfp.png', 0),
                            _buildDoctorOption(
                                'Dr. Ahmed El-Sayed', 'assets/images/pfp.png', 1),
                            _buildDoctorOption(
                                'Dr. Leila Hassan', 'assets/images/pfp.png', 2),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (childId.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content: Text('Child ID is invalid!')));
                                    return;
                                  }

                                  if (_formKey.currentState!.validate() &&
                                      selectedDoctor != null) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('children')
                                          .doc(childId)
                                          .update({'doctor': selectedDoctor});

                                      Navigator.pushNamed(context, '/add_photo');
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

  Widget _buildDoctorOption(String name, String imagePath, int index) {
    final bool isSelected = selectedDoctor == name;

    // تحديد لون كل دكتور عند الاختيار
    Color selectedColor;
    switch (index) {
      case 0:
        selectedColor = const Color(0xFFFFC0CB); // Baby Pink
        break;
      case 1:
        selectedColor = const Color(0xFFADD8E6); // Baby Blue
        break;
      case 2:
        selectedColor = const Color(0xFFE6E6FA); // Soft Lavender
        break;
      default:
        selectedColor = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDoctor = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor.withOpacity(0.8) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: selectedColor.withAlpha(60),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 26,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
