/// Form field validators shared across screens.
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static const minPasswordLength = 8;

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your full name';
    if (v.length < 2) return 'Name is too short';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email address';
    if (!_emailPattern.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Create a password';
    if (value.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Confirm your password';
      if (value != original()) return 'Passwords do not match';
      return null;
    };
  }
}
