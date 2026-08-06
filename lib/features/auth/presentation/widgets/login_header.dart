import 'package:flutter/material.dart';
import 'package:tomora/core/constants/app_images.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_text.dart';

class LoginHeader extends StatelessWidget {

  static const title = 'Login';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Text(
        //   AppText.welcomeBack,
        //    style: const TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 26,
        //     fontWeight: FontWeight.w600,
        //     color: AppColors.branco
        //   )
        // ),
        // const SizedBox(height: 18),
        // Image.asset(AppImages.logo, width: 150, height: 150),
        // const SizedBox(height: 18),
        SizedBox(
          height: 210,
        )
      ],
    );
  }
}