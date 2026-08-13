import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/primary_button.dart';
import 'package:tomora/features/auth/presentation/controllers/sign_controller.dart';
import 'package:tomora/features/auth/presentation/widgets/already_have.dart';
import 'package:tomora/features/auth/presentation/widgets/role_selector.dart';
import 'package:tomora/features/auth/presentation/widgets/sign_form.dart';
import 'package:tomora/features/auth/presentation/widgets/login_header.dart';

class SignPage extends StatelessWidget {
  SignPage({super.key});
  final controller = Get.put(SignController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cordefundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LoginHeader(),
                  SizedBox(height: 24),
                  SignForm(),
                  SizedBox(height: 24),
                  Center(child: RoleSelector()),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 320,
                    child: BotaoPrimario(texto: 'Entrar', onPressed: () {
                      controller.sign();
                    }),
                  ),
                  SizedBox(height: 24),
                  AlreadyHave()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
