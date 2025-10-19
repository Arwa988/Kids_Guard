import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/profile_row.dart';

class ProfileScreenDoc extends StatefulWidget {
  const ProfileScreenDoc({super.key});
  static const String routname = "/profile_screen_doc";

  @override
  State<ProfileScreenDoc> createState() => _ProfileScreenDocState();
}

class _ProfileScreenDocState extends State<ProfileScreenDoc> {
  // Sample data
  String username = "Maha Ahmed";
  String email = "MarwaMohamed@gmail.com";
  String? birthDateString;
  String age = "40 Years";
  String phone = "+201229451825";
  String address = "Alexandria";

  // Edit text field
  void _editField(String fieldName, String currentValue, ValueChanged<String> onSave) {
    final controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $fieldName'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType:
            fieldName == "Phone number" ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: fieldName,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return "This field is required";

              if (fieldName == "Email") {
                final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) return "Enter a valid email";
              }

              if (fieldName == "Phone number") {
                final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                if (!phoneRegex.hasMatch(value)) return "Enter a valid phone number";
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onSave(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Birthdate picker
  void _pickBirthDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1935),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      int calculatedAge = now.year - picked.year;
      if (now.month < picked.month ||
          (now.month == picked.month && now.day < picked.day)) {
        calculatedAge--;
      }
      String two(int n) => n.toString().padLeft(2, '0');
      final formatted = '${picked.year}-${two(picked.month)}-${two(picked.day)}';
      setState(() {
        birthDateString = formatted;
        age = "$calculatedAge Years";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.kTextColor),
                    ),
                  ],
                ),
              ),

              // Title + Avatar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextColor,
                      ),
                    ),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/pfp.png'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Info card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileRow(
                      title: "Username",
                      value: username,
                      onTap: () => _editField(
                          "Username", username, (val) => setState(() => username = val)),
                    ),
                    ProfileRow(
                      title: "Email",
                      value: email,
                      onTap: () => _editField(
                          "Email", email, (val) => setState(() => email = val)),
                    ),
                    ProfileRow(
                      title: "Birth Date",
                      value: birthDateString ?? "Select birth date",
                      onTap: _pickBirthDate,
                    ),
                    ProfileRow(
                      title: "Age",
                      value: age,
                      onTap: _pickBirthDate,
                    ),
                    ProfileRow(
                      title: "Phone number",
                      value: phone,
                      onTap: () => _editField(
                          "Phone number", phone, (val) => setState(() => phone = val)),
                    ),
                    ProfileRow(
                      title: "Address",
                      value: address,
                      onTap: () => _editField(
                          "Address", address, (val) => setState(() => address = val)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
