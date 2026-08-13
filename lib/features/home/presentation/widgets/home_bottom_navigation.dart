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
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.verde,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
            color: Colors.white,
            size: 27,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}