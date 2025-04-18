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
    final from = emojiToText ? '❤️ Emoji' : '🔤 Text';
    final to = emojiToText ? '🔤 Text' : '❤️ Emoji';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    from,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () => onModeToggle(!emojiToText),
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: 'Switch translation direction',
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    to,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: emojiToText ? 'Enter emoji' : 'Enter text',
            border: const OutlineInputBorder(),
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            onTap: isTranslating ? null : onTranslate,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isTranslating ? Colors.grey.shade200 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isTranslating ? Colors.grey.shade300 : Colors.blue.shade300,
                ),
              ),
              child: isTranslating
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Translate ✨',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
