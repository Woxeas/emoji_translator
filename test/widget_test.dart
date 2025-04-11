import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emoji_translator/app.dart';
import 'package:emoji_translator/main.dart';

void main() {
  testWidgets('App shows main screen title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EmojiTranslatorApp());

    // Verify that the title "Emoji Translator" is displayed.
    expect(find.text('Emoji Translator'), findsOneWidget);
  });
}
