import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Salted PBKDF2-HMAC-SHA256 password hashing.
///
/// Stored format: `pbkdf2_sha256$<iterations>$<salt b64>$<hash b64>`.
/// Hashing runs on a background isolate so the UI stays responsive.
class PasswordHasher {
  const PasswordHasher({this.iterations = 100000});

  static const _scheme = 'pbkdf2_sha256';
  static const _saltLength = 16;
  static const _keyLength = 32;

  final int iterations;

  Future<String> hash(String password) async {
    final random = Random.secure();
    final salt = List<int>.generate(_saltLength, (_) => random.nextInt(256));
    final pwd = utf8.encode(password);
    final rounds = iterations;
    final key = await Isolate.run(() => _pbkdf2(pwd, salt, rounds, _keyLength));
    return '$_scheme\$$rounds\$${base64.encode(salt)}\$${base64.encode(key)}';
  }

  Future<bool> verify(String password, String stored) async {
    final parts = stored.split(r'$');
    if (parts.length != 4 || parts[0] != _scheme) return false;
    final rounds = int.tryParse(parts[1]);
    if (rounds == null) return false;
    final salt = base64.decode(parts[2]);
    final expected = base64.decode(parts[3]);
    final pwd = utf8.encode(password);
    final actual = await Isolate.run(
      () => _pbkdf2(pwd, salt, rounds, expected.length),
    );
    return _constantTimeEquals(actual, expected);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

Uint8List _pbkdf2(List<int> password, List<int> salt, int rounds, int length) {
  final hmac = Hmac(sha256, password);
  final blockCount = (length / 32).ceil();
  final out = BytesBuilder();
  for (var block = 1; block <= blockCount; block++) {
    var u = hmac.convert([
      ...salt,
      (block >> 24) & 0xff,
      (block >> 16) & 0xff,
      (block >> 8) & 0xff,
      block & 0xff,
    ]).bytes;
    final t = Uint8List.fromList(u);
    for (var i = 1; i < rounds; i++) {
      u = hmac.convert(u).bytes;
      for (var k = 0; k < t.length; k++) {
        t[k] ^= u[k];
      }
    }
    out.add(t);
  }
  return Uint8List.sublistView(out.takeBytes(), 0, length);
}
