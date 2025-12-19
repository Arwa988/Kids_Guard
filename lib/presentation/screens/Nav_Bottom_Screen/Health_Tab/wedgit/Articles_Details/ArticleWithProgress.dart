import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';

class ArticleWithProgress extends StatefulWidget {
  const ArticleWithProgress({super.key});
  static const String routname = "/article_desc";

  @override
  State<ArticleWithProgress> createState() => _ArticleWithProgressState();
}

class _ArticleWithProgressState extends State<ArticleWithProgress> {
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
    final Data? passedArticle = args is Data ? args : null;
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => HealthTabModel()..getArticles(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthTabModel, HealthTabState>(
          builder: (context, state) {
            if (state is HealthTabLoadingState) return Loadingdesgin();
            if (state is HealthTabErrorState)
              return Center(child: Text("Error: ${state.error}"));

            if (state is HealthTabSucessState) {
              final article = passedArticle ?? (state.response.dataList?.first);

              return Stack(
                children: [
                  // الجزء الخاص بالمحتوى والسكرول
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        expandedHeight: 250,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: article?.image != null
                              ? Image.network(
                                  article!.image!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kids Guard",
                                style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // ✅ عرض المصدر المترجم
                              SizedBox(
                                child: Text(
                                  isArabic
                                      ? (article?.sourceAr ?? "")
                                      : (article?.source ?? ""),
                                  style: const TextStyle(color: Colors.black45),
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                ),
                              ),

                              // ✅ العنوان المترجم
                              Text(
                                isArabic
                                    ? (article?.titleAr ?? "")
                                    : (article?.title ?? ""),
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ✅ المحتوى المترجم كامل
                              Text(
                                isArabic
                                    ? (article?.contentAr ?? "")
                                    : (article?.content ?? ""),
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 🔴 الـ Progress Bar (موجود هنا في أعلى الشاشة)
                  Positioned(
                    top: MediaQuery.of(
                      context,
                    ).padding.top, // تحت الـ Status Bar بالظبط
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: _scrollProgress,
                      color: AppColors
                          .kPrimaryColor, // تأكدي إن اللون ده معرف عندك
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
