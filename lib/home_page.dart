// Main screen state and logic
import 'package:flutter/material.dart';
import 'widgets/translation_field.dart';
import 'widgets/ai_output_card.dart';
import 'services/chatgpt_service.dart';
import 'services/gemini_service.dart';
import 'services/grok_service.dart';
import 'services/deepseek_service.dart';
import 'services/supabase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _emojiToText = true;
  Map<String, String> _translations = {};

  Future<void> _translate() async {
    final input = _controller.text;
    if (input.isEmpty) return;

    setState(() => _translations.clear());

    final chatGpt = await translateWithChatGpt(input, _emojiToText);
    final gemini = await translateWithGemini(input, _emojiToText);
    final grok = await translateWithGrok(input, _emojiToText);
    final deepseek = await translateWithDeepSeek(input, _emojiToText);

    setState(() {
      _translations = {
        'ChatGPT': chatGpt,
        'Gemini': gemini,
        'Grok': grok,
        'DeepSeek': deepseek,
      };
    });

    if ([chatGpt, gemini, grok, deepseek].any((t) => t.trim().isNotEmpty)) {
      await incrementTranslationCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emoji Translator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TranslationField(
              controller: _controller,
              emojiToText: _emojiToText,
              onModeToggle: (val) => setState(() => _emojiToText = val),
              onTranslate: _translate,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: _translations.entries.map((entry) => AiOutputCard(
                  modelName: entry.key,
                  output: entry.value,
                  onBest: () => voteBest(entry.key),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}