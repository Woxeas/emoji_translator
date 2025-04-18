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
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isBest ? Colors.yellow.shade100.withOpacity(0.5) : null;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      SelectableText(
                        modelType,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
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
                          color: isBest ? Colors.amber : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isBest ? 'Voted as best' : 'Vote as best',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isBest ? Colors.amber.shade800 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            isLoading && output.trim().isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : output.isEmpty
                    ? const SizedBox(height: 20)
                    : SelectableText(
                        output,
                        style: const TextStyle(fontSize: 16),
                      ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.copy),
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