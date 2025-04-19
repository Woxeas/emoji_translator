import 'package:flutter/material.dart';

class TranslationField extends StatelessWidget {
  final TextEditingController controller;
  final bool emojiToText;
  final ValueChanged<bool> onModeToggle;
  final VoidCallback onTranslate;
  final bool isTranslating;

  const TranslationField({
    super.key,
    required this.controller,
    required this.emojiToText,
    required this.onModeToggle,
    required this.onTranslate,
    required this.isTranslating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ToggleButtons(
            isSelected: [!emojiToText, emojiToText],
            onPressed: (index) => onModeToggle(index == 1),
            renderBorder: true,       
            borderWidth: 1,
            borderRadius: BorderRadius.circular(24),
            borderColor: theme.colorScheme.outline,  
            selectedBorderColor: theme.colorScheme.outline, 
            fillColor: theme.colorScheme.primaryContainer,
            selectedColor: theme.colorScheme.onPrimaryContainer,
            color: theme.colorScheme.onSurfaceVariant,
            constraints: const BoxConstraints(
              minWidth: 140,
              minHeight: 40,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.text_fields, size: 20),
                  const SizedBox(width: 6),
                  Text('Text → Emoji', style: theme.textTheme.bodyMedium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_emotions, size: 20),
                  const SizedBox(width: 6),
                  Text('Emoji → Text', style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: emojiToText ? 'Enter emoji' : 'Enter text',
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),

        const SizedBox(height: 16),

        Center(
          child: SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: isTranslating ? null : onTranslate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: isTranslating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Translate ✨', style: theme.textTheme.labelLarge),
            ),
          ),
        ),
      ],
    );
  }
}
