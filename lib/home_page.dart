import 'package:flutter/material.dart';
import 'widgets/translation_field.dart';
import 'widgets/ai_output_card.dart';
import 'widgets/app_footer.dart';
import 'services/chatgpt_service.dart';
import 'services/gemini_service.dart';
import 'services/grok_service.dart';
import 'services/deepseek_service.dart';
import 'services/supabase_service.dart';

const Map<String, String> modelNamesWithType = {
  'ChatGPT': 'gpt-4o-mini',
  'Gemini': 'gemini-2.0-flash',
  'Grok': 'grok-3-mini-beta',
  'DeepSeek': 'deepseek-chat',
};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _emojiToText = false;
  Map<String, String> _translations = {
    for (var key in modelNamesWithType.keys) key: '',
  };
  bool _isTranslating = false;
  int _totalTranslations = 0;
  String? _mostVotedModel;
  String? _bestModel;

  Future<void> _loadStats() async {
    final total = await getTranslationCount();
    final topModel = await getMostVotedModel();
    setState(() {
      _totalTranslations = total;
      _mostVotedModel = topModel;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _translate() async {
    final input = _controller.text;
    if (input.isEmpty) return;

    setState(() {
      _isTranslating = true;
      _bestModel = null;
      _translations = {
        for (var key in modelNamesWithType.keys) key: '',
      };
    });

    final chatGpt = await translateWithChatGpt(input, _emojiToText);
    final gemini = await translateWithGemini(input, _emojiToText);
    final grok = await translateWithGrok(input, _emojiToText);
    final deepseek = await translateWithDeepSeek(input, _emojiToText);

    setState(() {
      _isTranslating = false;
      _translations = {
        'ChatGPT': chatGpt,
        'Gemini': gemini,
        'Grok': grok,
        'DeepSeek': deepseek,
      };
    });

    if ([chatGpt, gemini, grok, deepseek].any((t) => t.trim().isNotEmpty)) {
      await incrementTranslationCount();
      final updatedCount = await getTranslationCount();
      setState(() {
        _totalTranslations = updatedCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '✨ Emoji Translator ✨',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '🧮 Total translations: $_totalTranslations',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (_mostVotedModel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '🏆 Most voted model: $_mostVotedModel',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  const SizedBox(height: 16),
                  TranslationField(
                    controller: _controller,
                    emojiToText: _emojiToText,
                    onModeToggle: (val) => setState(() => _emojiToText = val),
                    onTranslate: _translate,
                    isTranslating: _isTranslating,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < modelNamesWithType.length) {
                  final entry = modelNamesWithType.entries.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AiOutputCard(
                      modelName: entry.key,
                      modelType: entry.value,
                      output: _translations[entry.key] ?? '',
                      isLoading: _isTranslating,
                      isBest: _bestModel == entry.key,
                      canVote: !_isTranslating &&
                              (_translations[entry.key]?.trim().isNotEmpty ?? false) &&
                              _bestModel == null,
                      onBest: () async {
                        setState(() => _bestModel = entry.key);
                        await voteBest(entry.key);
                        await _loadStats();
                      },
                    ),
                  );
                }
                if (index == modelNamesWithType.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: AppFooter(),
                  );
                }
                return null;
              },
              childCount: modelNamesWithType.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}