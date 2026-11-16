import '../models/home_models.dart';

/// TEMPORARY content for the Home screen layout.
///
/// This is not persisted data. It is replaced by SQLite-backed repositories
/// in Phase 4 (CLAUDE.md §8).
///
/// Images: drop files with these exact names into assets/images/... and they
/// appear automatically. Missing files fall back to a grey placeholder.
abstract final class HomeSampleData {
  static const activeAvatar = ActiveAvatarSummary(
    code: 'AURA-01',
    type: 'Female',
    bodyShape: 'Athletic',
    heightCm: 178,
  );

  static const activeLookName = 'Monochrome Drape V.04';
  static const activeLookImage = 'assets/images/home/studio_preview.jpg';
  static const piecesMounted = 3;
  static const piecesTotal = 3;

  static const stats = HomeStats(wardrobeItems: 142, savedLooks: 18, poses: 8);

  static const recentLooks = <LookPreview>[
    LookPreview(
      id: 'look_01',
      imagePath: 'assets/images/looks/look_01.jpg',
      number: 1,
      title: 'Brutalist Tailoring',
      line: 'Masculine line',
      description: 'Structured angular wool drape with industrial hardware.',
      tags: ['Blazer M-9', 'Wide slacks', 'Boost lug'],
    ),
    LookPreview(
      id: 'look_02',
      imagePath: 'assets/images/looks/look_02.jpg',
      number: 2,
      title: 'Monochrome Drape',
      line: 'Avant line',
      description: 'Layered asymmetric ruffles over a fitted base.',
      tags: ['Drape dress V.04', 'Ankle boot'],
    ),
    LookPreview(
      id: 'look_03',
      imagePath: 'assets/images/looks/look_03.jpg',
      number: 3,
      title: 'Utility Minimal',
      line: 'Street line',
      description: 'Clean technical layers with matte finishes.',
      tags: ['Shell jacket', 'Cargo pant', 'Cap 02'],
    ),
  ];

  static const capsules = <CapsulePreview>[
    CapsulePreview(
      id: 'capsule_01',
      imagePath: 'assets/images/capsules/capsule_01.jpg',
      number: 1,
      drop: 3,
      title: 'Monolith Capsule',
      pieceCount: 6,
      fabric: 'Rigid leather',
      note: 'Heavy tension',
    ),
    CapsulePreview(
      id: 'capsule_02',
      imagePath: 'assets/images/capsules/capsule_02.jpg',
      number: 2,
      drop: 1,
      title: 'Aerodynamic Silk',
      pieceCount: 8,
      fabric: 'Silk drape',
      note: 'Fluid motion',
    ),
  ];
}
