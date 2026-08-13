import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';

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
        Center(
          child: const Text(
            'Código do medicado',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 19,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white24,
            ),
            color: AppColors.campo,
          ),
          child: Column(
            children: [
              SizedBox(height: 3),
              Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.verde,
                ),
              ),
                child: TextButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(
                    Icons.content_copy,
                    size: 20,
                    color: AppColors.verde,
                  ),
                  label: const Text(
                    'Copiar Código',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.verde,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}