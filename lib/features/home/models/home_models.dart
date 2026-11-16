// Display models used by the Home screen.

class ActiveAvatarSummary {
  const ActiveAvatarSummary({
    required this.code,
    required this.type,
    required this.bodyShape,
    required this.heightCm,
  });

  final String code;
  final String type;
  final String bodyShape;
  final int heightCm;
}

class HomeStats {
  const HomeStats({
    required this.wardrobeItems,
    required this.savedLooks,
    required this.poses,
  });

  final int wardrobeItems;
  final int savedLooks;
  final int poses;
}

class LookPreview {
  const LookPreview({
    required this.id,
    required this.number,
    required this.title,
    required this.line,
    required this.description,
    required this.tags,
    this.imagePath,
  });

  final String id;
  final int number;
  final String title;
  final String line;
  final String description;
  final List<String> tags;
  final String? imagePath;
}

class CapsulePreview {
  const CapsulePreview({
    required this.id,
    required this.number,
    required this.drop,
    required this.title,
    required this.pieceCount,
    required this.fabric,
    required this.note,
    this.imagePath,
  });

  final String id;
  final int number;
  final int drop;
  final String title;
  final int pieceCount;
  final String fabric;
  final String note;
  final String? imagePath;
}
