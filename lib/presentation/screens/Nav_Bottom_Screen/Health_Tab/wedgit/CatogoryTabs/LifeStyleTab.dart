import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/grib_view_desgin/life_styleBulider.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerList.dart';

class Lifestyletab extends StatelessWidget {
  const Lifestyletab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // 🔹 Lifestyle Section
          BlocBuilder<HealthTabModel, HealthTabState>(
            buildWhen: (previous, current) =>
                current is LifeStyleSucessState ||
                current is LifeStyleLoadingState,
            builder: (context, state) {
              if (state is LifeStyleSucessState) {
                // ✅ Get the data from the Bloc instance
                final lifestyle = context.read<HealthTabModel>().lifestyleList;
                return LifeStylebulider(lifeArticles: lifestyle ?? []);
              }
              return const ShimmerList(count: 7);
            },
          ),
        ],
      ),
    );
  }
}
