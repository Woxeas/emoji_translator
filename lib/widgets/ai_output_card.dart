import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class AiOutputCard extends StatelessWidget {
  final String modelName;
  final String output;
  final VoidCallback onBest;
  final bool isLoading; 

  const AiOutputCard({
    super.key,
    required this.modelName,
    required this.output,
    required this.onBest,
    required this.isLoading,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: output));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  modelName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: onBest,
                  tooltip: 'Mark as best',
                ),
              ],
            ),
            const SizedBox(height: 12),
            isLoading && output.trim().isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (index) => Padding(
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
                  )),
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