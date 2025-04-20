import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

Future<String> translateWithGemini(String input, bool emojiToText) async {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey"
  );

  if (geminiApiKey.isEmpty) {
    print('[Gemini] Missing API key');
    return 'API key not configured';
  }

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  final systemPrompt = '''
You are an expert emoji translator.

When converting **text → emoji**:
• Output only a continuous string of emoji—no letters, digits, or punctuation.
• Be as comprehensive as possible: use as many emoji as needed to convey all nuances and details of the original text.
• Example:
  • Input: "I’m so excited for the concert tonight!"
  • Output: "🙋🤩🎫🎶🌙"

When converting **emoji → text**:
• Output fluent, plain English. You may use multiple sentences to convey everything implied.
• Example:
  • Input: "🍕🏠"
  • Output: "I’m ordering pizza to enjoy at home."

Always reply with exactly one translation and nothing else.
''';

  final userPrompt = emojiToText
      ? 'Convert the following emojis into English:\n$input'
      : 'Convert the following text into a continuous sequence of emoji:\n$input';

  final body = jsonEncode({
    'contents': [
      {
        'parts': [
          {'text': '$systemPrompt\n\n$userPrompt'}
        ]
      }
    ],
    'generationConfig': {
      'temperature': emojiToText ? 0.5 : 1.2,
      'topP': 1.0,
    },
  });

  try {
    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates != null && candidates.isNotEmpty) {
        var content = candidates[0]['content']['parts'][0]['text'] as String? ?? '';
        content = content.replaceAll('&#x27;', "'").trim();
        return content;
      } else {
        print('[Gemini] Empty candidates array');
        return 'No output';
      }
    } else {
      print('[Gemini] Error ${response.statusCode}: ${response.body}');
      return 'Translation failed';
    }
  } on TimeoutException {
    return 'Request timed out';
  } on SocketException {
    return 'No internet connection';
  } catch (e) {
    print('[Gemini] Unexpected error: $e');
    return 'Something went wrong';
  }
}