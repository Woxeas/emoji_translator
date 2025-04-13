import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

const deepSeekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY');

Future<String> translateWithDeepSeek(String input, bool emojiToText) async {
  final url = Uri.parse('https://api.deepseek.com/v1/chat/completions');

  if (deepSeekApiKey.isEmpty) {
    print('[DeepSeek] Missing API key');
    return 'API key not configured';
  }

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.authorizationHeader: 'Bearer $deepSeekApiKey',
  };

  final prompt = emojiToText
      ? 'Translate this emoji to text:\n$input'
      : 'Translate this text to emoji:\n$input';

  final systemPrompt = 'You are a helpful and consistent emoji translator. '
      'You translate emoji into plain, simple English. '
      'You also translate English text into emoji only. '
      'When translating text to emoji, reply using emoji only — no words, no explanations.';

  final body = jsonEncode({
    'model': 'deepseek-chat',
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': prompt},
    ],
    'temperature': 0.8,
  });

  try {
    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      // 👇 Dekódujeme přes bodyBytes pro správné zpracování UTF-8 (emoji!)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = data['choices'];
      if (choices != null && choices.isNotEmpty) {
        final content = choices[0]['message']['content'];
        return content?.trim() ?? 'No response';
      } else {
        print('[DeepSeek] Empty choices array');
        return 'No output';
      }
    } else {
      print('[DeepSeek] Error ${response.statusCode}: ${response.body}');
      return 'Translation failed';
    }
  } on TimeoutException {
    return 'Request timed out';
  } on SocketException {
    return 'No internet connection';
  } catch (e) {
    print('[DeepSeek] Unexpected error: $e');
    return 'Something went wrong';
  }
}
