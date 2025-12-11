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

  // Map article ID to video URLs
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

    if (passedArticle != null) {
      // Use article ID to get video URL
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
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    }
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
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final EmergencyData? passedArticle = args is EmergencyData ? args : null;

    return BlocProvider(
      create: (context) => HealthTabModel()..getEmergency(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HealthTabModel, HealthTabState>(
          builder: (context, state) {
            if (state is EmergencyLoadingState) {
              return const Loadingdesgin();
            } else if (state is EmergencyErrortate) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is EmergencySucesstate) {
              final emergency = passedArticle ??
                  (state.response.dataList != null &&
                      state.response.dataList!.isNotEmpty
                      ? state.response.dataList!.first
                      : null);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 0),
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
                                      child: Text("No video available")),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
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
                                (emergency?.contentList ?? []).join("\n"),
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
                    ],
                  ),
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
            return const Loadingdesgin();
          },
        ),
      ),
    );
  }
}
