import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

const openAiKey = String.fromEnvironment('OPENAI_API_KEY');

Future<String> translateWithChatGpt(String input, bool emojiToText) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  if (openAiKey.isEmpty) {
    print('[ChatGPT] Missing API key');
    return 'API key not configured';
  }

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.authorizationHeader: 'Bearer $openAiKey',
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
    'model': 'gpt-4o-mini',
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user',   'content': userPrompt},
    ],
    'temperature': emojiToText ? 0.5 : 1.2,
    'top_p': 1.0,
  });

  try {
    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = data['choices'];
      if (choices != null && choices.isNotEmpty) {
        var content = choices[0]['message']['content'] as String? ?? '';
        content = content.replaceAll('&#x27;', "'").trim();
        return content;
      } else {
        print('[ChatGPT] Empty choices array');
        return 'No output';
      }
    } else {
      print('[ChatGPT] Error ${response.statusCode}: ${response.body}');
      return 'Translation failed';
    }
  } on TimeoutException {
    return 'Request timed out';
  } on SocketException {
    return 'No internet connection';
  } catch (e) {
    print('[ChatGPT] Unexpected error: $e');
    return 'Something went wrong';
  }
}
