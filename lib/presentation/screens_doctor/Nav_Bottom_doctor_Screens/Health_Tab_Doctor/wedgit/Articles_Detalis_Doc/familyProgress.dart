import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/FamilyResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';

class Familyprogress extends StatefulWidget {
  const Familyprogress({super.key});
  static const String routname = "/family_desc";

  @override
  State<Familyprogress> createState() => _FamilyprogressState();
}

class _FamilyprogressState extends State<Familyprogress> {
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
    final FamilyData? passedArticle = args is FamilyData ? args : null;

    // ✅ تحديد اللغة الحالية
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => HealthdocModel()..getFam(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthdocModel, HealthdocState>(
          builder: (context, state) {
            if (state is FamilyLoadingState) return const Loadingdesgin();

            if (state is FamilyErrorState) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is FamilySucessState) {
              final family =
                  passedArticle ??
                  (state.response.dataList?.isNotEmpty == true
                      ? state.response.dataList!.first
                      : null);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // ✅ الصورة العلوية مع زر الرجوع
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        expandedHeight: 250,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: family?.image != null
                              ? Image.network(family!.image!, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported),
                        ),
                      ),

                      // ✅ المحتوى النصي بتصميم دائري من الأعلى
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
                              // ✅ تغيير المحاذاة حسب اللغة
                              crossAxisAlignment: isArabic
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Kids Guard",
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // ✅ المصدر
                                SizedBox(
                                  child: Text(
                                    isArabic
                                        ? (family?.sourceAr ?? "")
                                        : (family?.source ?? ""),
                                    style: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                    textAlign: isArabic
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    textDirection: isArabic
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // ✅ العنوان (يدعم العربي والإنجليزي)
                                Text(
                                  isArabic
                                      ? (family?.titleAr ?? "")
                                      : (family?.title ?? ""),
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ✅ المحتوى (يدعم العربي والإنجليزي)
                                Text(
                                  isArabic
                                      ? (family?.contentAr ?? "")
                                      : (family?.content ?? ""),
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  textAlign: isArabic
                                      ? TextAlign.justify
                                      : TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.8,
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
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
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
