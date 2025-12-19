import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/AiResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';

class Aiprogress extends StatefulWidget {
  const Aiprogress({super.key});
  static const String routname = "/ai_desc";

  @override
  State<Aiprogress> createState() => _AiprogressState();
}

class _AiprogressState extends State<Aiprogress> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) return; // ✅ تأكد من وجود المتحكم
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
    final AIData? passedArticle = args is AIData ? args : null;

    // ✅ تحديد اللغة الحالية
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => HealthdocModel()..getAi(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthdocModel, HealthdocState>(
          builder: (context, state) {
            if (state is AILoadingState) return const Loadingdesgin();

            if (state is AIErrorState) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is AISucessState) {
              final ai =
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
                      // ✅ الجزء العلوي: الصورة مع زر الرجوع
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        expandedHeight: 250,
                        automaticallyImplyLeading:
                            false, // نضعه يدويًا حسب اللغة
                        flexibleSpace: FlexibleSpaceBar(
                          background: ai?.image != null
                              ? Image.network(ai!.image!, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported),
                        ),
                      ),

                      // ✅ محتوى المقال داخل حاوية بيضاء مستديرة
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
                                // ✅ ضبط المحاذاة حسب اللغة
                                crossAxisAlignment: isArabic
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
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
                                  SizedBox(
                                    child: Text(
                                      isArabic
                                          ? (ai?.sourceAr ?? "")
                                          : (ai?.source ?? ""),
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

                                  // ✅ العنوان المترجم
                                  Text(
                                    isArabic
                                        ? (ai?.titleAr ?? "")
                                        : (ai?.title ?? ""),
                                    textDirection: isArabic
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    textAlign: isArabic
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 24,
                                        ),
                                  ),
                                  const SizedBox(height: 20),

                                  // ✅ المحتوى المترجم
                                  Text(
                                    isArabic
                                        ? (ai?.contentAr ?? "")
                                        : (ai?.content ?? ""),
                                    textDirection: isArabic
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    textAlign: isArabic
                                        ? TextAlign.justify
                                        : TextAlign.left,
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

                  // ✅ شريط التقدم العلوي
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Directionality(
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: LinearProgressIndicator(
                        value: _scrollProgress,
                        color: AppColors.kPrimaryColor,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        minHeight: 4,
                      ),
                    ),
                  ),

                  // ✅ زر الرجوع (يتغير مكانه حسب اللغة)
                  Positioned(
                    top: 40,
                    left: isArabic ? null : 15,
                    right: isArabic ? 15 : null,
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
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
