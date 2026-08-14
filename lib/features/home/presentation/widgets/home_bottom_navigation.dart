import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.campo,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 4,),
          _item(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {},
          ),

          _item(
            icon: Icons.add_box_outlined,
            label: 'Criar',
            onTap: () {
              Get.toNamed('/create');
            },
          ),

          _item(
            icon: Icons.help_outline,
            label: 'Dúvidas',
            onTap: () {
              Get.toNamed('/faq');
            },
          ),

          _item(
            icon: Icons.settings_outlined,
            label: 'Configurações',
            onTap: () {
              Get.toNamed('/settings');
            },
          ),
          SizedBox(width: 0,),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.branco,
            size: 36,
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.branco,
              fontSize: 10,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800
            ),
          ),
        ],
      ),
    );
  }
}