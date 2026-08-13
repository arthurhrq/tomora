import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/custom_text_field.dart';
import 'package:tomora/core/widgets/primary_button.dart';
import 'package:tomora/features/account_conection/presentation/controllers/connect_account_controller.dart';
import 'package:tomora/features/account_conection/presentation/widgets/connection_header.dart';

class ConnectAccountPage extends GetView<ConnectAccountController> {
  const ConnectAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const ConnectionHeader(
                    description:
                        'Insira o código identificador de seu medicado',
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: 320,
                    child: CampoPersonalizado(
                      title: 'Código do medicado',
                      controller: controller.codeController,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: 320,
                    height: 60,
                    child: Obx(
                      () => BotaoPrimario(
                        texto: controller.loading.value
                            ? 'Conectando...'
                            : 'Conectar Contas',
                        onPressed: controller.connect,
                      ),
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