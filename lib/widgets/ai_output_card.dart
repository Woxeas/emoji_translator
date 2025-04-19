import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class AiOutputCard extends StatelessWidget {
  final String modelName;
  final String modelType;
  final String output;
  final VoidCallback onBest;
  final bool isLoading;
  final bool isBest;
  final bool canVote;

  const AiOutputCard({
    super.key,
    required this.modelName,
    required this.modelType,
    required this.output,
    required this.onBest,
    required this.isLoading,
    required this.isBest,
    required this.canVote,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: output));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = isBest
        ? theme.colorScheme.secondaryContainer
        : theme.cardTheme.color ?? theme.colorScheme.surface;
    return Card(
      color: cardBg,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: theme.cardTheme.shape,
      elevation: theme.cardTheme.elevation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SelectableText(
                        modelName,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      SelectableText(
                        modelType,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (canVote || isBest)
                  InkWell(
                    onTap: canVote ? onBest : null,
                    borderRadius: BorderRadius.circular(24),
                    child: Row(
                      children: [
                        Icon(
                          isBest ? Icons.star : Icons.star_border,
                          color: isBest
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isBest ? 'Voted as best' : 'Vote as best',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isBest
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoading && output.trim().isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Shimmer.fromColors(
                      baseColor:
                          theme.colorScheme.surfaceContainerHighest,
                      highlightColor: theme.colorScheme.surface,
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  );
                }),
              )
            else if (output.isEmpty)
              const SizedBox(height: 20)
            else
              SelectableText(
                output,
                style: theme.textTheme.bodyLarge,
              ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.copy,
                  color: isBest
                      ? theme.colorScheme.onSecondaryContainer
                      : theme.colorScheme.primary,
                ),
                onPressed: () => _copyToClipboard(context),
                tooltip: 'Copy',
              ),
            ),
          ],
        ),
      ),
    );
  }
}