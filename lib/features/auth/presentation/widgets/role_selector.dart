import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tomora/core/constants/app_icons.dart';
import '../controllers/sign_controller.dart';

class RoleSelector extends StatelessWidget {
  RoleSelector({super.key});

  final SignController controller = Get.find<SignController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.roleController.value = 'MEDICADO';
              },
              child: Row(
                children: [
                   SvgPicture.asset(
                    AppIcons.medicado,
                    width: 24,
                    height: 25,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: const Text(
                      'Medicado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  Checkbox(
                    value: controller.roleController.value == 'MEDICADO',
                    onChanged: (_) {
                      controller.roleController.value = 'MEDICADO';
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.roleController.value = 'AUXILIAR';
              },
              child: Row(
                children: [
                   SvgPicture.asset(
                    AppIcons.auxiliar,
                    width: 24,
                    height: 25,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Auxiliar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  Checkbox(
                    value: controller.roleController.value == 'AUXILIAR',
                    onChanged: (_) {
                      controller.roleController.value = 'AUXILIAR';
                    },
                    
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}