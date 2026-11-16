class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.createdAt,
  });

  final int id;
  final String fullName;
  final String email;
  final DateTime createdAt;

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  factory AppUser.fromRow(Map<String, Object?> row) => AppUser(
        id: row['id']! as int,
        fullName: row['full_name']! as String,
        email: row['email']! as String,
        createdAt: DateTime.parse(row['created_at']! as String),
      );
}
