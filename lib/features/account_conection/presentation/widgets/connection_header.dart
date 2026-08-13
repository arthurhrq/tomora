import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConnectionHeader extends StatelessWidget {
  final String description;

  const ConnectionHeader({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/linking.svg',
          width: 200,
          height: 200,
        ),
        SizedBox(height: 16),
        Text(
          'Conexão de Contas',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      ],
    );
  }
}