import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/primary_button.dart';
import 'package:tomora/features/account_conection/presentation/widgets/connection_code_display.dart';
import 'package:tomora/features/account_conection/presentation/widgets/connection_header.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/routes/app_routes.dart';

class ConnectionCodePage extends StatelessWidget {
  const ConnectionCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Normalmente o código vem por argumento (fluxo de cadastro/login).
    // Mas quando a sessão é restaurada automaticamente ao reabrir o app
    // (ver main.dart), navegamos direto pra essa rota sem argumento —
    // nesse caso, usamos o id do usuário já carregado no UserController.
    final args = Get.arguments;
    final String connectionCode =
        args is String ? args : Get.find<UserController>().user.id;

    return Scaffold(
      backgroundColor: AppColors.cordefundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConnectionHeader(
                    description:
                        'Esse é o código identificador que você deve informar ao seu auxiliar',
                  ),

                  const SizedBox(height: 24),

                  ConnectionCodeDisplay(
                    code: connectionCode,
                    onCopy: () {},
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: 320,
                    height: 60,
                    child: BotaoPrimario(
                      texto: 'Prosseguir',
                      onPressed: () {
                        // offAllNamed limpa a pilha - evita essa tela
                        // ser reconstruída sem argumento depois (ex: back).
                        Get.offAllNamed(AppRoutes.home);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}