import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/MedicalResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';

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
    if (!_scrollController.hasClients) return;
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
    final MedicalData? passedArticle = args is MedicalData ? args : null;
    
    // ✅ تحديد إذا كانت اللغة عربية
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => HealthdocModel()..getMed(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthdocModel, HealthdocState>(
          builder: (context, state) {
            if (state is MedicaldocLoadingState) return const Loadingdesgin();
            
            if (state is MedicaldocErrorState) {
              return Center(child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)));
            }

            if (state is MedicalTabSucessState) {
              final med = passedArticle ?? (state.response.medicalDataList?.isNotEmpty == true 
                  ? state.response.medicalDataList!.first 
                  : null);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // ✅ جزء الصورة العلوية
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        expandedHeight: 250,
                        automaticallyImplyLeading: false, // سنضع زر الرجوع يدوياً للتحكم في مكانه
                        flexibleSpace: FlexibleSpaceBar(
                          background: med?.image != null
                              ? Image.network(med!.image!, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported),
                        ),
                      ),

                      // ✅ المحتوى النصي داخل حاوية بيضاء مستديرة
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              // ✅ محاذاة العمود حسب اللغة
                              crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kids Guard",
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // ✅ المصدر المترجم
                                Text(
                                  isArabic ? (med?.sourceAr ?? "") : (med?.source ?? ""),
                                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // ✅ العنوان المترجم
                                Text(
                                  isArabic ? (med?.titleAr ?? "") : (med?.title ?? ""),
                                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ✅ المحتوى المترجم
                                Text(
                                  isArabic ? (med?.contentAr ?? "") : (med?.content ?? ""),
                                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                  textAlign: isArabic ? TextAlign.justify : TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.8,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ✅ زر الرجوع (يتغير مكانه حسب اللغة)
                  Positioned(
                    top: 40,
                    left: isArabic ? null : 15,
                    right: isArabic ? 15 : null,
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  // ✅ شريط التقدم العلوي
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: _scrollProgress,
                      color: AppColors.kPrimaryColor,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      minHeight: 5,
                    ),
                  ),
                ],
              );
            }
            return const Loadingdesgin();
          },
        ),
      ),
    );
  }
}