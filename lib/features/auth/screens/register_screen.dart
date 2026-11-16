import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/pill_button.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_repository.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_message.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_switch_link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await context.read<AuthController>().register(
            fullName: _name.text,
            email: _email.text,
            password: _password.text,
          );
      TextInput.finishAutofillContext();
      // Signed in: AuthGate now shows the app underneath — drop this route.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                eyebrow: 'New atelier',
                title: 'Create account',
                subtitle: 'Set up your profile to save avatars and looks.',
              ),
              const SizedBox(height: 36),
              AppTextField(
                controller: _name,
                hint: 'Full name',
                icon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: Validators.fullName,
              ),
              const SizedBox(height: 14),
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
                hint: 'Password (min. ${Validators.minPasswordLength} characters)',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.newPassword,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _confirm,
                hint: 'Confirm password',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(() => _password.text),
                onSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                AuthMessage(_error!),
              ],
              const SizedBox(height: 28),
              PillButton(
                label: 'Create account',
                trailingIcon: Icons.arrow_forward_rounded,
                expand: true,
                loading: _submitting,
                onPressed: _submit,
              ),
              const SizedBox(height: 14),
              Text(
                'Your account is stored only on this device.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 8),
              AuthSwitchLink(
                prompt: 'Already have an account?',
                action: 'Sign in',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
