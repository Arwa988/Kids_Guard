import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/grib_view_desgin/heart_gribBulider.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerList.dart';

class Hearttab extends StatelessWidget {
  const Hearttab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // 🔹 Heart Section
          BlocBuilder<HealthTabModel, HealthTabState>(
            buildWhen: (previous, current) =>
                current is HealthTabSucessState ||
                current is HealthTabLoadingState,
            builder: (context, state) {
              if (state is HealthTabSucessState) {
                final articles = context.read<HealthTabModel>().articlesList;
                return HeartGribbulider(articleList: articles ?? []);
              }
              return const ShimmerList(count: 5);
            },
          ),
        ],
      ),
    );
  }
}
