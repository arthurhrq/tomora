import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/features/account_conection/presentation/widgets/connection_code_display.dart';
import 'package:tomora/features/account_conection/presentation/widgets/connection_header.dart';

class ConnectionCodePage extends StatelessWidget {
  const ConnectionCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cordefundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConnectionHeader(),
                  SizedBox(height: 24),
                  ConnectionCodeDisplay(
                    code: '123456',
                    onCopy: () {
                      
                    },
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