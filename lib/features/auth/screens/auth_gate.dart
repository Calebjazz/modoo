import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/navigation/app_shell.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

/// Chooses between the splash, the login flow and the main app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (context.watch<AuthController>().status) {
      AuthStatus.loading => const _Splash(),
      AuthStatus.signedOut => const LoginScreen(),
      AuthStatus.signedIn => const AppShell(),
    };
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppInfo.name,
          style: AppTextStyles.label.copyWith(fontSize: 14, letterSpacing: 8),
        ),
      ),
    );
  }
}
