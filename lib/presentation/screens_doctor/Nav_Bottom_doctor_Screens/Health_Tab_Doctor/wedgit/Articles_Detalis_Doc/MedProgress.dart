import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/MedicalResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/health_tab_doc.dart';

class MedicalProgess extends StatefulWidget {
  const MedicalProgess({super.key});
  static const String routname = "/medical_desc";

  @override
  State<MedicalProgess> createState() => _MedicalProgessState();
}

class _MedicalProgessState extends State<MedicalProgess> {
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
    final MedicalData? passedArticle = args is MedicalData ? args : null;
    // by5zn el args dy by2olo hya data esm list byt3t el articles

    return BlocProvider(
      create: (context) => HealthdocModel()..getMed(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthdocModel, HealthdocState>(
          builder: (context, state) {
            if (state is MedicaldocLoadingState) {
              return Loadingdesgin();
            } else if (state is MedicaldocErrorState) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is MedicalTabSucessState) {
              final med =
                  passedArticle ??
                  (state.response.medicalDataList != null &&
                          state.response.medicalDataList!.isNotEmpty
                      ? state.response.medicalDataList!.first
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
                          background: med?.image != null
                              ? Image.network(med!.image!, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported),
                        ),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      // 👇 White rounded container BELOW the image
                      SliverToBoxAdapter(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kids Guard",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.pinkAccent,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    med?.source ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    med?.title ?? "",
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
                                    med?.content ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 2,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
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
