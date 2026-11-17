import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';

abstract final class ProfileAccountDialogs {
  static Future<void> editIdentity(
    BuildContext context,
    String currentName,
  ) async {
    final formKey = GlobalKey<FormState>();
    var enteredName = currentName;
    final auth = context.read<AuthController>();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit identity'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: currentName,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Full name'),
            onChanged: (value) => enteredName = value,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter your name'
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, enteredName.trim());
              }
            },
            child: const Text('SAVE IDENTITY'),
          ),
        ],
      ),
    );
    if (name == null || !context.mounted) return;
    try {
      await auth.updateDisplayName(name);
    } catch (error) {
      if (context.mounted) {
        _message(context, 'Could not update identity: $error');
      }
    }
  }

  static Future<void> copyProfile(
    BuildContext context,
    String name,
    int? memberNumber,
  ) async {
    final member = memberNumber == null ? '' : ' · Member #$memberNumber';
    await Clipboard.setData(ClipboardData(text: '$name$member · MODOO'));
    if (context.mounted) _message(context, 'Profile details copied');
  }

  static Future<void> memberCard(
    BuildContext context,
    String name,
    String email,
    int? memberNumber,
  ) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.qr_code_2_rounded, size: 32),
      title: const Text('ATELIER MEMBER'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: AppTextStyles.title),
          const SizedBox(height: 6),
          Text(email, style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Text(
            'LOCAL MEMBER  //  ${memberNumber == null ? '—' : '#$memberNumber'}',
            style: AppTextStyles.eyebrow,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
      ],
    ),
  );

  static Future<void> unavailable(BuildContext context, String message) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Not available yet'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('GOT IT'),
            ),
          ],
        ),
      );

  static void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
