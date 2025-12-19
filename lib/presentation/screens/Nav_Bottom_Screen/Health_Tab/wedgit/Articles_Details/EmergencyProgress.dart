import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/loadingDesgin.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Emergencyprogress extends StatefulWidget {
  const Emergencyprogress({super.key});
  static const String routname = "/emergency_desc";

  @override
  State<Emergencyprogress> createState() => _EmergencyprogressState();
}

class _EmergencyprogressState extends State<Emergencyprogress> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  YoutubePlayerController? _youtubeController;

  final Map<num, String> articleVideos = {
    1: "https://youtu.be/a9lR6Z4gzwQ",
    2: "https://youtu.be/c7Q1s7ppSwc",
    3: "https://youtu.be/DByqyhLV1zg",
    4: "https://youtu.be/vrrdnl7vQpM",
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final EmergencyData? passedArticle = args is EmergencyData ? args : null;

    if (passedArticle != null && _youtubeController == null) {
      final videoUrl = articleVideos[passedArticle.id ?? 0];
      if (videoUrl != null && videoUrl.isNotEmpty) {
        _initYoutubeController(videoUrl);
      }
    }
  }

  void _initYoutubeController(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
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
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final EmergencyData? passedArticle = args is EmergencyData ? args : null;

    // ✅ التحقق من لغة التطبيق
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => HealthTabModel()..getEmergency(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthTabModel, HealthTabState>(
          builder: (context, state) {
            if (state is EmergencyLoadingState) return const Loadingdesgin();
            if (state is EmergencyErrortate)
              return Center(child: Text("Error: ${state.error}"));

            if (state is EmergencySucesstate) {
              final emergency =
                  passedArticle ?? (state.response.dataList?.first);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // ✅ الجزء الخاص بالفيديو
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            80.0,
                            16.0,
                            0,
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: _youtubeController != null
                                    ? YoutubePlayer(
                                        controller: _youtubeController!,
                                        showVideoProgressIndicator: true,
                                        progressIndicatorColor:
                                            AppColors.kPrimaryColor,
                                      )
                                    : Container(
                                        height: 200,
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Text("No video available"),
                                        ),
                                      ),
                              ),
                              // زر الرجوع
                              Positioned(
                                top: 8,
                                left: isArabic ? null : 8,
                                right: isArabic ? 8 : null,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  child: IconButton(
                                    icon: Icon(
                                      isArabic
                                          ? Icons.arrow_back_ios_new
                                          : Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ✅ الجزء الخاص بالنصوص
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),
                          child: Column(
                            // ضبط المحاذاة حسب اللغة
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
                              const SizedBox(height: 15),

                              // العنوان المترجم
                              Text(
                                isArabic
                                    ? (emergency?.titleAr ?? "")
                                    : (emergency?.title ?? ""),
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 25),

                              // المحتوى المترجم (الخطوات)
                              Text(
                                isArabic
                                    ? (emergency?.contentListAr.join("\n\n") ??
                                          "")
                                    : (emergency?.contentList?.join("\n\n") ??
                                          ""),
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
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
                    ],
                  ),

                  // 🔴 شريط التقدم (Progress Bar)
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
