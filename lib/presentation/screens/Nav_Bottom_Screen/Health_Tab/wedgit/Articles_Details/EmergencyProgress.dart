import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/health_tab.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Emergencyprogress extends StatefulWidget {
  const Emergencyprogress({super.key});
  static const String routname = "/emergency_desc";

  @override
  State<Emergencyprogress> createState() => _EmergencyprogressState();
}

class _EmergencyprogressState extends State<Emergencyprogress> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  void _updateProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (maxScroll > 0) {
      setState(() {
        _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    // line dah by stkbl el argument el etba3t fy file healthtab
    final EmergencyData? passedArticle = args is EmergencyData ? args : null;
    // by5zn el args dy by2olo hya data esm list byt3t el articles

    return BlocProvider(
      create: (context) => HealthTabModel()..getEmergency(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthTabModel, HealthTabState>(
          builder: (context, state) {
            if (state is EmergencyLoadingState) {
              return Loadingdesgin();
            } else if (state is EmergencyErrortate) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is EmergencySucesstate) {
              // dy sabab en 4a4aha el red lma a3ml refreash mattl34
              final emergency =
                  passedArticle ??
                  (state.response.dataList != null &&
                          state.response.dataList!.isNotEmpty
                      ? state.response.dataList!.first
                      : null);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        expandedHeight: 250,

                        flexibleSpace: FlexibleSpaceBar(
                          background: Image(
                            image: AssetImage("assets/images/Ai2.png"),
                          ),
                        ),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop(); // <-- go back to previous screen
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kids Guard",
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              SizedBox(height: 8),
                              // Text(
                              //   emergency.source ?? "",
                              //   style: Theme.of(context).textTheme.bodySmall!
                              //       .copyWith(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w400,
                              //       ),
                              // ),
                              const SizedBox(height: 10),
                              Text(
                                emergency?.title ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const SizedBox(height: 20),

                              Text(
                                (emergency?.contentList ?? []).join(
                                  "\n",
                                ), // ✅ join list into single string
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 2, // increases line height
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 🔵 Progress bar at the top
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: _scrollProgress,
                      color: AppColors.kPrimaryColor,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      minHeight: 4,
                    ),
                  ),
                ],
              );
            }

            return Loadingdesgin();
          },
        ),
      ),
    );
  }
}
