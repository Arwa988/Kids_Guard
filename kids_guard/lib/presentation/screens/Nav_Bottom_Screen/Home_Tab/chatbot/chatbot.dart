import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

class ChatbotScreen extends StatelessWidget {
  static const routeName = '/chatbot';

  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lexendStyle = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF365D81)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7DDE6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Lottie.asset(
                        'assets/lottie/Phoenix.json',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hello, Child Guardian!\nHow are you feeling today?',
                    textAlign: TextAlign.center,
                    style: lexendStyle.titleLarge?.copyWith(
                      fontFamily: 'Lexend',
                      color: const Color(0xFF365D81),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 18),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDEAF9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text('How am I doing with my weight gain goal?'),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 18),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDEAF9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text('How am I processing in the step challenge?'),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDEAF9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text('How is my blood pressure?'),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Ask me anything',
                                      style: lexendStyle.bodyLarge?.copyWith(
                                        fontFamily: 'Lexend',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.mic_none,
                                      color: Colors.black45),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
