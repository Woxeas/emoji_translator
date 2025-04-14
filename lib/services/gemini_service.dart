import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

Future<String> translateWithGemini(String input, bool emojiToText) async {
  final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey");

  if (geminiApiKey.isEmpty) {
    print('[Gemini] Missing API key');
    return 'API key not configured';
  }

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  final prompt = emojiToText
      ? 'Translate this emoji to text:\n$input'
      : 'Translate this text to emoji:\n$input';

  final systemPrompt = 'You are a helpful and consistent emoji translator. '
      'You translate emoji into plain, simple English. '
      'You also translate English text into emoji only. '
      'When translating text to emoji, reply using emoji only — no words, no explanations.';

  final body = jsonEncode({
    'contents': [
      {
        'parts': [
          {'text': '$systemPrompt\n\n$prompt'}
        ]
      }
    ],
    'generationConfig': {
      'temperature': 0.8,
    }
  });

  try {
    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final candidates = data['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content']['parts'][0]['text'];
        return content?.trim() ?? 'No response';
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