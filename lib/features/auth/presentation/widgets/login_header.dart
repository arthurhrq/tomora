import 'package:flutter/material.dart';

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
          height: 170,
        )
      ],
    );
  }
}