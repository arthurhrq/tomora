import 'package:flutter/material.dart';

class ConnectionCodeDisplay extends StatelessWidget {
  final String code;
  final VoidCallback onCopy;

  const ConnectionCodeDisplay({
    super.key,
    required this.code,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Código do medicado',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white24,
            ),
          ),
          child: Column(
            children: [
              Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 8),

              TextButton.icon(
                onPressed: onCopy,
                icon: const Icon(
                  Icons.content_copy,
                  size: 14,
                ),
                label: const Text(
                  'Copiar Código',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}