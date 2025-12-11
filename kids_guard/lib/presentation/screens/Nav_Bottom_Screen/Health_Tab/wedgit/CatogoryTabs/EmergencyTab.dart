import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/grib_view_desgin/emergency_grib.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerList.dart';

class EmergencyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          BlocBuilder<HealthTabModel, HealthTabState>(
            buildWhen: (previous, current) =>
                current is EmergencySucesstate ||
                current is EmergencyLoadingState,
            builder: (context, state) {
              if (state is EmergencySucesstate) {
                final emergency = context.read<HealthTabModel>().emergencyList;
                return EmergencyGrib(emergencyList: emergency ?? []);
              }
              return const ShimmerList(count: 4);
            },
          ),
        ],
      ),
    );
  }
}
