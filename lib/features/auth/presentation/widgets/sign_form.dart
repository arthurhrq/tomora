import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/custom_text_field.dart';
import 'package:tomora/features/auth/presentation/controllers/sign_controller.dart';

class SignForm extends StatelessWidget {

  final controller = Get.find<SignController>();
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Registre-se',
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
              'Crie sua conta',
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
            title: 'Nome',
            controller: controller.nameController,
            hintText: 'Digite seu nome',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 11.0),
              child: Icon(Icons.person, color: AppColors.branco),
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 320,
          child: CampoPersonalizado(
            title: 'Email',
            controller: controller.emailController,
            hintText: 'Digite seu email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 11.0),
              child: Icon(Icons.email_outlined, color: AppColors.branco),
            ),
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
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 11.0),
              child: Icon(Icons.lock_outline, color: AppColors.branco),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}