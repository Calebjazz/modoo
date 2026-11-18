class SavedLook {
  const SavedLook({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.date,
    required this.itemCount,
    required this.imagePath,
  });

  final String id;
  final int number;
  final String title;
  final String description;
  final String date;
  final int itemCount;
  final String? imagePath;
}
