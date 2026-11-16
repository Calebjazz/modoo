import 'package:flutter/material.dart';

import '../../../shared/widgets/phase_pending_view.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhasePendingView(
      eyebrow: 'Digital wardrobe',
      title: 'Wardrobe',
      message:
          'Browse tops, bottoms, dresses, jackets, shoes, caps and accessories. '
          'Arrives with the clothing catalogue (Phase 4).',
      icon: Icons.checkroom_outlined,
    );
  }
}
