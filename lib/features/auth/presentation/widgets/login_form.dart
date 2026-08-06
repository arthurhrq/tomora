import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/custom_text_field.dart';
import 'package:tomora/features/auth/presentation/controllers/login_controller.dart';

class LoginForm extends StatelessWidget {

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: AppColors.branco,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Entre em sua conta',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: AppColors.branco,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 320,
          child: CampoPersonalizado(
            title: 'Email',
            controller: controller.emailController,
            hintText: 'Digite seu email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email, color: AppColors.branco),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 320,
          child: CampoPersonalizado(
            title: 'Senha',
            controller: controller.passwordController,
            hintText: 'Digite sua senha',
            obscureText: true,
            prefixIcon: Icon(Icons.lock, color: AppColors.branco),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}