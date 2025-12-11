import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/profile_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routname = "/profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
// Profile Backend
///first state of profile screen///
class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Loading...";
  String email = "Loading...";
  String age = "Loading...";
  String disease = "Loading...";
  String weight = "Loading...";
  String doctor = "Loading...";
  String phone = "Loading...";
  String address = "Loading...";
  String? birthDateString; // hidden but used for computing age

  final List<String> diseaseTypes = [
    "Cardiac Arrhythmia",
    "Cyanotic Congenital",
  ];
  final List<String> doctors = [
    "Dr Haidy Abdelkerem",
    "Dr Ahmed Farouk",
    "Dr Salma Nasser",
    "Dr Youssef Adel"
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // function that Load user data from firebase
  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() => isLoading = true);

    try {
      final guardianSnap = await FirebaseFirestore.instance
          .collection('guardian')
          .doc(currentUser.uid)
          .get();

      final childSnap = await FirebaseFirestore.instance
          .collection('children')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (mounted) {
        setState(() {
          email = guardianSnap.data()?['email'] ?? "Not provided";
          phone = guardianSnap.data()?['phone'] ?? "Not provided";

          if (childSnap.docs.isNotEmpty) {
            final child = childSnap.docs.first.data();
            username = child['name'] ?? "N/A";
            birthDateString = child['birthDate'];
            disease = child['diseaseType'] ?? "N/A";
            weight = child['weight'] ?? "N/A";
            doctor = child['doctor'] ?? "N/A";
            address = child['address'] ?? "N/A";

            // Compute age from stored birth date
            if (birthDateString != null && birthDateString!.isNotEmpty) {
              try {
                final parts = birthDateString!.split('/');
                if (parts.length == 3) {
                  final birthDate = DateTime(
                    int.parse(parts[2]),
                    int.parse(parts[0]),
                    int.parse(parts[1]),
                  );
                  final now = DateTime.now();
                  int calculatedAge = now.year - birthDate.year;
                  if (now.month < birthDate.month ||
                      (now.month == birthDate.month && now.day < birthDate.day)) {
                    calculatedAge--;
                  }
                  age = "$calculatedAge Years";
                }
              } catch (e) {
                age = "Unknown";
              }
            } else {
              age = "Unknown";
            }
          }
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Update data in Firestore
  Future<void> _updateField({
    required String collection,
    required String docId,
    required String field,
    required dynamic value,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(docId).update({
        field: value,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  String _getFirestoreFieldName(String visibleName) {
    switch (visibleName) {
      case "Username":
        return "name";
      case "Disease Type":
        return "diseaseType";
      case "Current Weight":
        return "weight";
      case "Doctor":
        return "doctor";
      case "Address":
        return "address";
      case "Email":
        return "email";
      case "Phone number":
        return "phone";
      default:
        return visibleName.toLowerCase();
    }
  }

  void _editField(
      String fieldName, String currentValue, ValueChanged<String> onSave) {
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
            keyboardType: fieldName == "Phone number"
                ? TextInputType.phone
                : TextInputType.text,
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
                final phoneRegex = RegExp(r'^(?:\+20|0)?1[0-9]{9}$');
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newValue = controller.text;
                Navigator.pop(context);
                onSave(newValue);

                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  final field = _getFirestoreFieldName(fieldName);
                  if (fieldName == "Email" || fieldName == "Phone number") {
                    await _updateField(
                      collection: 'guardian',
                      docId: currentUser.uid,
                      field: field,
                      value: newValue,
                    );
                  } else {
                    final childSnap = await FirebaseFirestore.instance
                        .collection('children')
                        .where('userId', isEqualTo: currentUser.uid)
                        .limit(1)
                        .get();
                    if (childSnap.docs.isNotEmpty) {
                      await _updateField(
                        collection: 'children',
                        docId: childSnap.docs.first.id,
                        field: field,
                        value: newValue,
                      );
                    }
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editDropdown(
      String fieldName, List<String> options, String currentValue, ValueChanged<String> onSave) {
    String selected = options.contains(currentValue) ? currentValue : options.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select $fieldName"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: selected,
            items: options
                .map((opt) => DropdownMenuItem(
              value: opt,
              child: Text(opt, style: const TextStyle(color: Colors.black87)),
            ))
                .toList(),
            onChanged: (val) => setStateDialog(() => selected = val!),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              onSave(selected);
              Navigator.pop(context);
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                final field = _getFirestoreFieldName(fieldName);
                final childSnap = await FirebaseFirestore.instance
                    .collection('children')
                    .where('userId', isEqualTo: currentUser.uid)
                    .limit(1)
                    .get();
                if (childSnap.docs.isNotEmpty) {
                  await _updateField(
                    collection: 'children',
                    docId: childSnap.docs.first.id,
                    field: field,
                    value: selected,
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Calendar to select birth date and update age
  void _pickBirthDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2020, 1, 1),
      firstDate: DateTime(2007),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      int calculatedAge = now.year - picked.year;
      if (now.month < picked.month ||
          (now.month == picked.month && now.day < picked.day)) {
        calculatedAge--;
      }

      final formatted = "${picked.month}/${picked.day}/${picked.year}";

      setState(() {
        birthDateString = formatted;
        age = "$calculatedAge Years";
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final childSnap = await FirebaseFirestore.instance
            .collection('children')
            .where('userId', isEqualTo: currentUser.uid)
            .limit(1)
            .get();
        if (childSnap.docs.isNotEmpty) {
          await _updateField(
            collection: 'children',
            docId: childSnap.docs.first.id,
            field: 'birthDate',
            value: formatted,
          );
        }
      }
    }
  }
// Profile UI
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.kTextColor),
                    ),
                    IconButton(
                      onPressed: _loadUserData,
                      icon: const Icon(Icons.refresh, color: AppColors.kTextColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("My Profile",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kTextColor)),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/pfp.png'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                        offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileRow(
                      title: "Username",
                      value: username,
                      onTap: () =>
                          _editField("Username", username, (v) => setState(() => username = v)),
                    ),
                    ProfileRow(
                      title: "Email",
                      value: email,
                      onTap: () =>
                          _editField("Email", email, (v) => setState(() => email = v)),
                    ),
                    ProfileRow(
                      title: "Age",
                      value: age,
                      onTap: _pickBirthDate, // tap to open calendar
                    ),
                    ProfileRow(
                        title: "Disease Type",
                        value: disease,
                        onTap: () => _editDropdown(
                            "Disease Type", diseaseTypes, disease, (v) => setState(() => disease = v))),
                    ProfileRow(
                        title: "Current Weight",
                        value: weight,
                        onTap: () => _editField(
                            "Current Weight", weight, (v) => setState(() => weight = v))),
                    ProfileRow(
                        title: "Doctor",
                        value: doctor,
                        onTap: () => _editDropdown(
                            "Doctor", doctors, doctor, (v) => setState(() => doctor = v))),
                    ProfileRow(
                        title: "Phone number",
                        value: phone,
                        onTap: () => _editField(
                            "Phone number", phone, (v) => setState(() => phone = v))),
                    ProfileRow(
                        title: "Address",
                        value: address,
                        onTap: () => _editField(
                            "Address", address, (v) => setState(() => address = v))),
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
