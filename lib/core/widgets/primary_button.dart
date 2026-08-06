import 'package:flutter/material.dart' show StatelessWidget, ElevatedButton;
import 'package:flutter/widgets.dart';
import 'package:tomora/core/theme/app_colors.dart';

class BotaoPrimario extends StatelessWidget {
   final String texto;
   final VoidCallback onPressed;

   const BotaoPrimario({
     Key? key,
     required this.texto,
     required this.onPressed,
   }) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return ElevatedButton(
       onPressed: onPressed,
       style: ElevatedButton.styleFrom(
         backgroundColor: AppColors.roxo, // Cor de fundo do botão
         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(30),
         ),
       ),
       child: Text(
         texto,
         style: TextStyle(
           color: AppColors.branco,
           fontFamily: 'Poppins',
           fontSize: 20,
           fontWeight: FontWeight.w700,
         ),
       ),
     );
   }
}