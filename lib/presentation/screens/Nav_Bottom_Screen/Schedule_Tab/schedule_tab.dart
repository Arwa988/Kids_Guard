import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

import 'medication/medication_page.dart';
import 'appointments/doc_appointment.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kLightBlue,
        elevation: 0,
        centerTitle: true,
        title: null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 18,
            ),
            tabs: const [
              Tab(text: "Medication"),
              Tab(text: "Appointments"),
            ],
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: const [
          MedicationPage(),
          DocAppointment(
            doctorId: 'HEEH0twV0rWVvVdhLcUkyc8cszH2',
            doctorName: 'Dr. ali',
          ),
        ],
      ),
    );
  }
}