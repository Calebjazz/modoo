import 'package:flutter/material.dart';

import '../../../shared/widgets/phase_pending_view.dart';

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhasePendingView(
      eyebrow: 'Virtual fashion studio',
      title: 'Studio',
      message:
          'The interactive 3D avatar will render here once the Flutter–Unity '
          'integration is proven (Phase 1).',
      icon: Icons.view_in_ar_rounded,
    );
  }
}
