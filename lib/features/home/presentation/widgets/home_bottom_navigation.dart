import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/routes/app_routes.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
  });

  // Ainda não existem em AppRoutes (telas não implementadas ainda),
  // mas já deixamos centralizado aqui pra facilitar quando existirem.
  static const _faqRoute = '/faq';
  static const _settingsRoute = '/settings';

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

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
          const SizedBox(width: 4),

          _item(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: currentRoute == AppRoutes.home,
            onTap: () => _goTo(
              AppRoutes.home,
              currentRoute,
              // Limpa a pilha: garante que a Home sempre volte a
              // funcionar mesmo vindo da tela de criação de lembrete.
              clearStack: true,
            ),
          ),

          _item(
            icon: Icons.add_box_outlined,
            label: 'Criar',
            selected: currentRoute == AppRoutes.create,
            onTap: () => _goTo(AppRoutes.create, currentRoute),
          ),

          _item(
            icon: Icons.help_outline,
            label: 'Dúvidas',
            selected: currentRoute == _faqRoute,
            onTap: () => _goTo(_faqRoute, currentRoute),
          ),

          _item(
            icon: Icons.settings_outlined,
            label: 'Configurações',
            selected: currentRoute == _settingsRoute,
            onTap: () => _goTo(_settingsRoute, currentRoute),
          ),

          const SizedBox(width: 0),
        ],
      ),
    );
  }

  /// Navega para [route]. Se já estivermos nela, não faz nada (evita
  /// empilhar a mesma tela em cima dela mesma). Quando [clearStack] é
  /// true, limpa toda a pilha de navegação antes de ir — é o que resolve
  /// o botão "Home" não funcionar quando vindo de telas empilhadas
  /// (como a de criação de lembrete).
  void _goTo(
    String route,
    String currentRoute, {
    bool clearStack = false,
  }) {
    if (currentRoute == route) return;

    if (clearStack) {
      Get.offAllNamed(route);
    } else {
      Get.toNamed(route);
    }
  }

  Widget _item({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = selected ? AppColors.verde : AppColors.branco;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 36,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            // Bolinha indicadora da aba ativa.
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: selected ? AppColors.verde : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}