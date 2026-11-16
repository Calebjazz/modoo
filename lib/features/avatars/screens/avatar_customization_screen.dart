import 'package:flutter/material.dart';

import '../../../shared/widgets/phase_pending_view.dart';

class AvatarCustomizationScreen extends StatelessWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CUSTOMIZE AVATAR')),
      body: const PhasePendingView(
        eyebrow: 'Avatar system',
        title: 'Customize',
        message:
            'Skin tone, body shape, height and proportions. Arrives with the '
            'avatar system (Phase 2).',
        icon: Icons.tune_rounded,
      ),
    );
  }
}
