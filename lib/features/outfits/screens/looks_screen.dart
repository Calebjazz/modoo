import 'package:flutter/material.dart';

import '../../../shared/widgets/phase_pending_view.dart';

class LooksScreen extends StatelessWidget {
  const LooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhasePendingView(
      eyebrow: 'Outfit management',
      title: 'Saved looks',
      message:
          'Save, rename, edit and reapply outfits. Arrives with SQLite '
          'persistence (Phase 4).',
      icon: Icons.style_outlined,
    );
  }
}
