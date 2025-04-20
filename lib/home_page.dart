import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/language_selector.dart';
import 'widgets/translation_field.dart';
import 'widgets/ai_output_card.dart';
import 'widgets/app_footer.dart';
import 'services/chatgpt_service.dart';
import 'services/gemini_service.dart';
import 'services/grok_service.dart';
import 'services/deepseek_service.dart';
import 'services/supabase_service.dart';
import 'utils/validation.dart'; 

const Map<String, String> modelNamesWithType = {
  'ChatGPT': 'gpt-4o-mini',
  'Gemini': 'gemini-2.0-flash',
  'Grok': 'grok-3-mini-beta',
  'DeepSeek': 'deepseek-chat',
};

class HomePage extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

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
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    if (_emojiToText) {
      if (!isEmojiOnly(input)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOnlyEmoji)),
        );
        return;
      }
    } else {
      if (!isTextOnly(input)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOnlyText)),
        );
        return;
      }
    }

    final langCode = Localizations.localeOf(context).languageCode;

    setState(() {
      _isTranslating = true;
      _bestModel = null;
      _translations = {
        for (var key in modelNamesWithType.keys) key: '',
      };
    });

    final results = await Future.wait([
      translateWithChatGpt(input, _emojiToText, langCode),
      translateWithGemini(input, _emojiToText, langCode),
      translateWithGrok(input, _emojiToText, langCode),
      translateWithDeepSeek(input, _emojiToText, langCode),
    ]);

    final chatGpt  = results[0];
    final gemini   = results[1];
    final grok     = results[2];
    final deepseek = results[3];

    setState(() {
      _isTranslating = false;
      _translations = {
        'ChatGPT':  chatGpt,
        'Gemini':   gemini,
        'Grok':     grok,
        'DeepSeek': deepseek,
      };
    });

    if ([_translations.values].any((list) => list.any((t) => t.trim().isNotEmpty))) {
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
    final loc = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: LanguageSelector(
                            currentLocale: currentLocale,
                            onLocaleChange: widget.onLocaleChange,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            loc.appTitle,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 64,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              loc.appTitle,
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: LanguageSelector(
                              currentLocale: currentLocale,
                              onLocaleChange: widget.onLocaleChange,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      loc.totalTranslations(_totalTranslations),
                      style: theme.textTheme.bodyMedium, 
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_mostVotedModel != null) ...[
                    const SizedBox(height: 4),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        loc.mostVotedModel(_mostVotedModel!),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  SizedBox(
                    height: isMobile ? 24.0 : 36.0,
                  ),
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
                          (_translations[entry.key]?.trim().isNotEmpty ??
                              false) &&
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