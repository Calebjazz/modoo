import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/auth/services/password_hasher.dart';

void main() {
  const hasher = PasswordHasher(iterations: 1000);

  test('verifies the right password and rejects a wrong one', () async {
    final stored = await hasher.hash('correct horse');
    expect(stored, startsWith(r'pbkdf2_sha256$1000$'));
    expect(stored, isNot(contains('correct horse')));
    expect(await hasher.verify('correct horse', stored), isTrue);
    expect(await hasher.verify('wrong horse', stored), isFalse);
  });

  test('same password gets a different salt each time', () async {
    expect(await hasher.hash('abc12345'), isNot(await hasher.hash('abc12345')));
  });

  test('matches the RFC 6070-style PBKDF2-HMAC-SHA256 reference vector',
      () async {
    // password="password", salt="salt", c=1, dkLen=32
    const stored = r'pbkdf2_sha256$1$c2FsdA==$Eg+2z/z4syxD5yJSVsT4N6hlSMkszDVICAWYfLcL4Xs=';
    expect(await hasher.verify('password', stored), isTrue);
  });
}
