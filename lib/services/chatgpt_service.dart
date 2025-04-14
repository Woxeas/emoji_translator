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

  final prompt = emojiToText
      ? 'Translate this emoji to text:\n$input'
      : 'Translate this text to emoji:\n$input';

  final systemPrompt = 'You are a helpful and consistent emoji translator. '
           'You translate emoji into plain, simple English. '
           'You also translate English text into emoji only. '
           'When translating text to emoji, reply using emoji only — no words, no explanations.';

  final body = jsonEncode({
    'model': 'gpt-4o-mini',
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': prompt}
    ],
    'temperature': 0.8,
  });

  try {
    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = data['choices'];
      if (choices != null && choices.isNotEmpty) {
        final content = choices[0]['message']['content'];
        return content?.trim() ?? 'No response';
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
