import 'package:characters/characters.dart';
import 'package:emoji_regex/emoji_regex.dart';

bool isEmojiOnly(String input) {
  final emojiReg = emojiRegex();
  for (final cluster in input.characters) {
    if (!emojiReg.hasMatch(cluster)) return false;
  }
  return input.isNotEmpty;
}

bool isTextOnly(String input) {
  final emojiReg = emojiRegex();
  for (final cluster in input.characters) {
    if (emojiReg.hasMatch(cluster)) return false;
  }
  return input.isNotEmpty;
}
