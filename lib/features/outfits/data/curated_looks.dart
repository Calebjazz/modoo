import '../../studio/models/studio_garment.dart';
import '../models/outfit.dart';

/// Read-only starter looks built from garments in the studio catalogue.
abstract final class CuratedLooks {
  static const looks = <Outfit>[
    Outfit(
      name: 'Noir Tailoring',
      avatarId: 'AURA',
      garmentIds: {
        StudioGarmentSlot.outerwear: 'tech-blazer',
        StudioGarmentSlot.top: 'ribbed-mockneck',
        StudioGarmentSlot.bottom: 'tapered-trouser',
      },
      imagePath: 'assets/images/looks/look_01.jpg',
    ),
    Outfit(
      name: 'Cyber Minimalism',
      avatarId: 'AURA',
      garmentIds: {
        StudioGarmentSlot.outerwear: 'leather-shacket',
        StudioGarmentSlot.top: 'crop-knit',
        StudioGarmentSlot.bottom: 'cargo-slacks',
      },
      imagePath: 'assets/images/looks/look_02.jpg',
    ),
    Outfit(
      name: 'Architectural Drape',
      avatarId: 'AURA',
      garmentIds: {
        StudioGarmentSlot.outerwear: 'wool-overcoat',
        StudioGarmentSlot.bottom: 'wide-slacks',
      },
      imagePath: 'assets/images/looks/look_03.jpg',
    ),
    Outfit(
      name: 'Monochrome Casual',
      avatarId: 'KAI',
      garmentIds: {
        StudioGarmentSlot.top: 'cotton-jersey',
        StudioGarmentSlot.bottom: 'cargo-slacks',
      },
      imagePath: 'assets/images/looks/look_04.jpg',
    ),
  ];
}
