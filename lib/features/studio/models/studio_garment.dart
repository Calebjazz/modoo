import 'package:flutter/material.dart';

enum StudioGarmentCategory { tops, bottoms, outerwear }

enum StudioGarmentSlot { top, bottom, outerwear }

extension StudioGarmentCategoryLabel on StudioGarmentCategory {
  String get label => switch (this) {
    StudioGarmentCategory.tops => 'Tops',
    StudioGarmentCategory.bottoms => 'Bottoms',
    StudioGarmentCategory.outerwear => 'Outerwear',
  };
}

class StudioGarment {
  const StudioGarment({
    required this.id,
    required this.name,
    required this.material,
    required this.finish,
    required this.category,
    required this.slot,
    required this.icon,
  });

  final String id;
  final String name;
  final String material;
  final String finish;
  final StudioGarmentCategory category;
  final StudioGarmentSlot slot;
  final IconData icon;

  String get slotLabel => switch (slot) {
    StudioGarmentSlot.top => 'Top',
    StudioGarmentSlot.bottom => 'Btm',
    StudioGarmentSlot.outerwear => 'Outer',
  };
}

abstract final class StudioPreviewCatalog {
  static StudioGarment? byId(String? id) {
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static int countIn(StudioGarmentCategory category) =>
      items.where((item) => item.category == category).length;

  static const items = <StudioGarment>[
    StudioGarment(
      id: 'ribbed-mockneck',
      name: 'Ribbed Mockneck',
      material: 'Cotton',
      finish: 'Equip',
      category: StudioGarmentCategory.tops,
      slot: StudioGarmentSlot.top,
      icon: Icons.checkroom_outlined,
    ),
    StudioGarment(
      id: 'crop-knit',
      name: 'Crop Knit',
      material: 'Fine knit',
      finish: 'Soft',
      category: StudioGarmentCategory.tops,
      slot: StudioGarmentSlot.top,
      icon: Icons.dry_cleaning_outlined,
    ),
    StudioGarment(
      id: 'cotton-jersey',
      name: 'Cotton Jersey',
      material: 'Cotton',
      finish: 'Light',
      category: StudioGarmentCategory.tops,
      slot: StudioGarmentSlot.top,
      icon: Icons.checkroom_outlined,
    ),
    StudioGarment(
      id: 'cargo-slacks',
      name: 'Cargo Slacks',
      material: 'Technical wool',
      finish: 'Relaxed',
      category: StudioGarmentCategory.bottoms,
      slot: StudioGarmentSlot.bottom,
      icon: Icons.straighten_rounded,
    ),
    StudioGarment(
      id: 'wide-slacks',
      name: 'Wide Slacks',
      material: 'Wool blend',
      finish: 'Fluid',
      category: StudioGarmentCategory.bottoms,
      slot: StudioGarmentSlot.bottom,
      icon: Icons.straighten_rounded,
    ),
    StudioGarment(
      id: 'tapered-trouser',
      name: 'Tapered Trouser',
      material: 'Cotton twill',
      finish: 'Structured',
      category: StudioGarmentCategory.bottoms,
      slot: StudioGarmentSlot.bottom,
      icon: Icons.straighten_rounded,
    ),
    StudioGarment(
      id: 'wool-overcoat',
      name: 'Wool Overcoat',
      material: 'Raw wool',
      finish: 'Heavy',
      category: StudioGarmentCategory.outerwear,
      slot: StudioGarmentSlot.outerwear,
      icon: Icons.checkroom_outlined,
    ),
    StudioGarment(
      id: 'tech-blazer',
      name: 'Tech Blazer',
      material: 'Nylon',
      finish: 'Technical',
      category: StudioGarmentCategory.outerwear,
      slot: StudioGarmentSlot.outerwear,
      icon: Icons.checkroom_outlined,
    ),
    StudioGarment(
      id: 'leather-shacket',
      name: 'Leather Shacket',
      material: 'Leather',
      finish: 'Rigid',
      category: StudioGarmentCategory.outerwear,
      slot: StudioGarmentSlot.outerwear,
      icon: Icons.checkroom_outlined,
    ),
  ];
}
