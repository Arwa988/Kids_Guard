import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';

class Lifestyleprogress extends StatefulWidget {
  const Lifestyleprogress({super.key});
  static const String routname = "/life_desc";

  @override
  State<Lifestyleprogress> createState() => _LifestyleprogressState();
}

class _LifestyleprogressState extends State<Lifestyleprogress> {
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
    final lifestyleData? passedArticle = args is lifestyleData ? args : null;

    // ✅ التأكد من لغة التطبيق
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => HealthTabModel()..getStyle(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthTabModel, HealthTabState>(
          builder: (context, state) {
            if (state is LifeStyleLoadingState) return Loadingdesgin();
            if (state is LifeStyleErrorState)
              return Center(child: Text("Error: ${state.error}"));

            if (state is LifeStyleSucessState) {
              final lifestyle =
                  passedArticle ?? (state.response.dataList?.first);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        expandedHeight: 250,
                        pinned: true, // عشان يفضل موجود وإنتِ بتعملي سكرول
                        flexibleSpace: FlexibleSpaceBar(
                          background: lifestyle?.image != null
                              ? Image.network(
                                  lifestyle!.image!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),
                          child: Column(
                            // ✅ الاتجاه حسب اللغة
                            crossAxisAlignment: isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kids Guard",
                                style: const TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // ✅ عرض المصدر المترجم
                              SizedBox(
                                
                                child: Text(
                                  isArabic
                                      ? (lifestyle?.sourceAr ?? "")
                                      : (lifestyle?.source ?? ""),
                                  style: const TextStyle(color: Colors.black45),
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                ),
                              ),
                              const SizedBox(height: 15),

                              // ✅ العنوان المترجم
                              Text(
                                isArabic
                                    ? (lifestyle?.titleAr ?? "")
                                    : (lifestyle?.title ?? ""),
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 25),

                              // ✅ المحتوى المترجم الكامل
                              Text(
                                isArabic
                                    ? (lifestyle?.contentAr ?? "")
                                    : (lifestyle?.content ?? ""),
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 19,
                                  height: 1.9,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 🔴 شريط التقدم (Progress Bar) - يظهر في أعلى الشاشة
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
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
