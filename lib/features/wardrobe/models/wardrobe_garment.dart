import 'package:flutter/material.dart';

enum WardrobeCategory { tops, bottoms, outerwear, shoes, accessories }

extension WardrobeCategoryLabel on WardrobeCategory {
  String get label => switch (this) {
    WardrobeCategory.tops => 'Tops',
    WardrobeCategory.bottoms => 'Bottoms',
    WardrobeCategory.outerwear => 'Outerwear',
    WardrobeCategory.shoes => 'Shoes',
    WardrobeCategory.accessories => 'Accessories',
  };
}

class WardrobeGarment {
  const WardrobeGarment({
    required this.id,
    required this.category,
    required this.name,
    required this.finish,
    required this.material,
    required this.description,
    required this.icon,
  });

  final String id;
  final WardrobeCategory category;
  final String name;
  final String finish;
  final String material;
  final String description;
  final IconData icon;
}

abstract final class WardrobeCatalog {
  static const items = <WardrobeGarment>[
    WardrobeGarment(
      id: 'architectural-overcoat',
      category: WardrobeCategory.outerwear,
      name: 'Architectural Overcoat',
      finish: 'Onyx',
      material: 'Heavy wool',
      description: '3 cuts available',
      icon: Icons.checkroom_rounded,
    ),
    WardrobeGarment(
      id: 'cargo-trouser',
      category: WardrobeCategory.bottoms,
      name: 'Cargo Trouser',
      finish: 'Charcoal',
      material: 'Rigid twill',
      description: 'Straight / flared',
      icon: Icons.straighten_rounded,
    ),
    WardrobeGarment(
      id: 'poplin-shirt',
      category: WardrobeCategory.tops,
      name: 'Poplin Shirt',
      finish: 'Optical',
      material: 'Light drape',
      description: '2 silhouettes',
      icon: Icons.dry_cleaning_outlined,
    ),
    WardrobeGarment(
      id: 'lug-sole-derby',
      category: WardrobeCategory.shoes,
      name: 'Lug-Sole Derby',
      finish: 'Polished',
      material: 'Rigid mesh',
      description: 'Platform 5cm',
      icon: Icons.shopping_bag_outlined,
    ),
    WardrobeGarment(
      id: 'wrap-midi-skirt',
      category: WardrobeCategory.bottoms,
      name: 'Wrap Midi Skirt',
      finish: 'Deep ash',
      material: 'Fluid foil',
      description: 'Asymmetric hem',
      icon: Icons.waves_rounded,
    ),
    WardrobeGarment(
      id: 'wire-sunglasses',
      category: WardrobeCategory.accessories,
      name: 'Wire Sunglasses',
      finish: 'Silver / black',
      material: 'Metallic shader',
      description: 'Titanium wire',
      icon: Icons.remove_red_eye_outlined,
    ),
  ];
}
