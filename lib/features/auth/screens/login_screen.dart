import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/pill_button.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_repository.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_message.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_switch_link.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await context.read<AuthController>().signIn(
        email: _email.text,
        password: _password.text,
      );
      TextInput.finishAutofillContext();
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _openRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                eyebrow: 'Studio atelier',
                title: 'Welcome back',
                subtitle: 'Sign in to continue styling your avatar.',
              ),
              const SizedBox(height: 36),
              AppTextField(
                controller: _email,
                hint: 'Email address',
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _password,
                hint: 'Password',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: Validators.password,
                onSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                AuthMessage(_error!),
              ],
              const SizedBox(height: 28),
              PillButton(
                label: 'Sign in',
                trailingIcon: Icons.arrow_forward_rounded,
                expand: true,
                loading: _submitting,
                onPressed: _submit,
              ),
              const SizedBox(height: 20),
              AuthSwitchLink(
                prompt: "Don't have an account?",
                action: 'Create one',
                onTap: _openRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
