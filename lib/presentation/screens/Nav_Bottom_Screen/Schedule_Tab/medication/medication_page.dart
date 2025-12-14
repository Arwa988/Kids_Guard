import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/core/constants/services/firebase_service.dart';
import 'package:kids_guard/core/constants/services/medication_service.dart';
import 'widgets/medication_controller.dart';
import 'widgets/medication_form.dart';
import 'widgets/medication_card.dart';

class MedicationPage extends StatefulWidget {
  static const routname = '/medication';
  const MedicationPage({Key? key}) : super(key: key);

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final MedicationController _controller = MedicationController();
  final FirebaseService _firebaseService = FirebaseService();
  String _filter = 'today';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _firebaseService.initialize();
      

      if (!_firebaseService.isLoggedIn) {
      } else {

        _controller.initializeStreams();
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error initializing app: $e');
      setState(() => _isLoading = false);

      _showErrorDialog('Failed to connect to server. Please check your internet connection.');
    }
  }

  void _openForm({Medication? edit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return MedicationForm(
          edit: edit,
          onSave: (med) async {
            try {
              if (edit == null) {
                await _controller.addMedication(med);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medication added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                await _controller.editMedication(edit.id, med);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medication updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Medications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _filter,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black54,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'today',
                  child: Text('Today'),
                ),
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All'),
                ),
              ],
              onChanged: (v) => setState(() => _filter = v!),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightBlue,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _filter == 'today' ? _buildTodayView() : _buildAllView(),
      ),
    );
  }

  Widget _buildTodayView() {
    return StreamBuilder<List<MedicationDose>>(
      stream: _controller.todayDosesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final doses = snapshot.data ?? [];

        if (doses.isEmpty) {
          return const Center(
            child: Text(
              'No medications for today',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: doses.length,
          itemBuilder: (context, idx) {
            final dose = doses[idx];
            return MedicationCard(
              dose: dose,
              onTapCheck: () async {
                final onTime = await _controller.markTakenWithCheck(dose.id);
                if (onTime) {
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Nice!'),
                      content: const Text('Great job — you took it on time.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Heads up'),
                      content: const Text(
                          'It\'s important to take medicine on time.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              onEdit: () {
                final medication = _controller.getMedicationById(dose.medId);
                if (medication != null) {
                  _openForm(edit: medication);
                }
              },
              onDelete: () {
                _confirmDelete(dose.medId);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAllView() {
    return StreamBuilder<List<Medication>>(
      stream: _controller.medicationsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final meds = snapshot.data ?? [];

        if (meds.isEmpty) {
          return const Center(
            child: Text(
              'No medications',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: meds.length,
          itemBuilder: (context, idx) {
            final med = meds[idx];
            return ListTile(
              title: Text(med.name),
              subtitle: Text(
                  '${med.dosage} • ${med.times.map((t) => t.format(context)).join(', ')}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _openForm(edit: med),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.errorRed),
                    onPressed: () => _confirmDelete(med.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this medication?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
    
    if (res == true) {
      try {
        await _controller.deleteMedication(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medication deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}