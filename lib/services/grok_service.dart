import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

const grokApiKey = String.fromEnvironment('GROK_API_KEY');

Future<String> translateWithGrok(String input, bool emojiToText) async {
  final url = Uri.parse('https://api.x.ai/v1/chat/completions');

  if (grokApiKey.isEmpty) {
    print('[Grok] Missing API key');
    return 'API key not configured';
  }

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.authorizationHeader: 'Bearer $grokApiKey',
  };

  final prompt = emojiToText
      ? 'Translate this emoji to text:\n$input'
      : 'Translate this text to emoji:\n$input';

  final systemPrompt = 'You are a helpful and consistent emoji translator. '
      'You translate emoji into plain, simple English. '
      'You also translate English text into emoji only. '
      'When translating text to emoji, reply using emoji only — no words, no explanations.';

  final body = jsonEncode({
    'model': 'grok-3-mini-beta', // or whichever model is correct
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
        print('[Grok] Empty choices array');
        return 'No output';
      }
    } else {
      print('[Grok] Error ${response.statusCode}: ${response.body}');
      return 'Translation failed';
    }
  } on TimeoutException {
    return 'Request timed out';
  } on SocketException {
    return 'No internet connection';
  } catch (e) {
    print('[Grok] Unexpected error: $e');
    return 'Something went wrong';
  }
}