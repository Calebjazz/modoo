import 'package:flutter/material.dart';

enum AvatarCustomizationSection { model, bodyShape, proportions }

enum AvatarFrame {
  full('Full'),
  upper('Upper'),
  head('Head');

  const AvatarFrame(this.label);

  final String label;
}

class AvatarProfile {
  const AvatarProfile({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final String type;

  String get label => '${type.toUpperCase()} [$name]';
}

class AvatarTone {
  const AvatarTone({required this.name, required this.color});

  final String name;
  final Color color;
}

abstract final class AvatarCustomizationOptions {
  static const profiles = <AvatarProfile>[
    AvatarProfile(id: 'kai', name: 'KAI', type: 'Male'),
    AvatarProfile(id: 'aura', name: 'AURA', type: 'Female'),
    AvatarProfile(id: 'nova', name: 'NB', type: 'Nova'),
  ];

  static const tones = <AvatarTone>[
    AvatarTone(name: 'Porcelain', color: Color(0xFFFFFFFF)),
    AvatarTone(name: 'Ivory', color: Color(0xFFF3F3F3)),
    AvatarTone(name: 'Neutral ash', color: Color(0xFFE0E0E0)),
    AvatarTone(name: 'Stone', color: Color(0xFF9A9A9A)),
    AvatarTone(name: 'Umber', color: Color(0xFF5F5F5F)),
    AvatarTone(name: 'Espresso', color: Color(0xFF262626)),
    AvatarTone(name: 'Onyx', color: Color(0xFF000000)),
  ];

  static const bodyShapes = <String>['Standard', 'Athletic', 'Curved'];
}
