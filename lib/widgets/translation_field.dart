// Input field and mode toggle widget
import 'package:flutter/material.dart';

class TranslationField extends StatelessWidget {
  final TextEditingController controller;
  final bool emojiToText;
  final ValueChanged<bool> onModeToggle;
  final VoidCallback onTranslate;

  const TranslationField({
    super.key,
    required this.controller,
    required this.emojiToText,
    required this.onModeToggle,
    required this.onTranslate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Enter text or emoji'),
        ),
        SwitchListTile(
          title: const Text('Emoji → Text'),
          value: emojiToText,
          onChanged: onModeToggle,
        ),
        ElevatedButton(
          onPressed: onTranslate,
          child: const Text('Translate'),
        ),
      ],
    );
  }
}
