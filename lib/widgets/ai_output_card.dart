// AI model result + BEST button
import 'package:flutter/material.dart';

class AiOutputCard extends StatelessWidget {
  final String modelName;
  final String output;
  final VoidCallback onBest;

  const AiOutputCard({
    super.key,
    required this.modelName,
    required this.output,
    required this.onBest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('$modelName:'),
        subtitle: Text(output),
        trailing: IconButton(
          icon: const Icon(Icons.star_border),
          onPressed: onBest,
        ),
      ),
    );
  }
}