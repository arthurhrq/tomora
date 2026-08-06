import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';

class CampoPersonalizado extends StatelessWidget {
  
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool enabled;


  const CampoPersonalizado({
    super.key,
    this.title,
    this.controller,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title ?? '',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.branco,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.hinttext,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  errorText: errorText,
                  prefixIcon: prefixIcon,
                  filled: true,
                  fillColor: AppColors.campo,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 17.0,
                    horizontal: 19.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: BorderSide(
                      color: AppColors.contorno,
                      width: 1.0
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: BorderSide(
                      color: AppColors.branco,
                      width: 1.2
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}