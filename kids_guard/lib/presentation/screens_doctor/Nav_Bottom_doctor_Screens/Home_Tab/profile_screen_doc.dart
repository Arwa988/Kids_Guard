import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/profile_row.dart';

class ProfileScreenDoc extends StatefulWidget {
  const ProfileScreenDoc({super.key});
  static const String routname = "/profile_screen_doc";

  @override
  State<ProfileScreenDoc> createState() => _ProfileScreenDocState();
}
// Profile screen backend
class _ProfileScreenDocState extends State<ProfileScreenDoc> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String firstname = "Loading...";
  String lastname = "Loading...";
  String gender = "Loading...";
  String phoneNumber = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  /// Load doctor data from Firestore (doctors collection)
  Future<void> _loadDoctorData() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final docSnap = await _firestore
          .collection('doctors')
          .doc(currentUser.uid)
          .get();

      if (docSnap.exists) {
        final data = docSnap.data()!;
        setState(() {
          firstname = data['firstname'] ?? "Not provided";
          lastname = data['lastname'] ?? "Not provided";
          gender = data['gender'] ?? "Not provided";
          phoneNumber = data['phone_number'] ?? "Not provided";
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        print("No doctor found for UID: ${currentUser.uid}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error loading doctor data: $e");
    }
  }

  /// Update a specific field in Firestore
  Future<void> _updateField(String firestoreKey, String newValue) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("doctors").doc(user.uid).update({
        firestoreKey: newValue,
      });
    }
  }

  /// Edit field dialog
  void _editField(String fieldName, String firestoreKey, String currentValue,
      ValueChanged<String> onSave) {
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
            keyboardType: fieldName == "Phone Number"
                ? TextInputType.phone
                : TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: fieldName,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This field is required";
              }
              if (fieldName == "Phone Number") {
                final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                if (!phoneRegex.hasMatch(value)) {
                  return "Enter a valid phone number";
                }
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newValue = controller.text.trim();
                onSave(newValue);
                await _updateField(firestoreKey, newValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// UI of Profile Doc
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.kTextColor),
                ),
              ),

              // 👤 Title + Avatar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextColor,
                      ),
                    ),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage:
                      AssetImage('assets/images/pfp.png'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🧾 Profile Info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileRow(
                      title: "First Name",
                      value: firstname,
                      onTap: () => _editField(
                        "First Name",
                        "firstname",
                        firstname,
                            (val) => setState(() => firstname = val),
                      ),
                    ),
                    ProfileRow(
                      title: "Last Name",
                      value: lastname,
                      onTap: () => _editField(
                        "Last Name",
                        "lastname",
                        lastname,
                            (val) => setState(() => lastname = val),
                      ),
                    ),
                    ProfileRow(
                      title: "Gender",
                      value: gender,
                      onTap: () => _editField(
                        "Gender",
                        "gender",
                        gender,
                            (val) => setState(() => gender = val),
                      ),
                    ),
                    ProfileRow(
                      title: "Phone Number",
                      value: phoneNumber,
                      onTap: () => _editField(
                        "Phone Number",
                        "phone_number",
                        phoneNumber,
                            (val) => setState(() => phoneNumber = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
