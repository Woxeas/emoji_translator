// Root widget + MaterialApp
import 'package:flutter/material.dart';
import 'home_page.dart';

class EmojiTranslatorApp extends StatelessWidget {
  const EmojiTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Translator',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      fontFamily: 'Roboto', 
      fontFamilyFallback: ['NotoColorEmoji'],
    ),
      home: const HomePage(),
    );
  }
}