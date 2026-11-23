import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/auth/models/app_user.dart';
import 'package:modoo/main.dart';

import 'fake_auth_repository.dart';
import 'fake_outfit_repository.dart';

void main() {
  testWidgets('Profile shows account stats and saves identity edits', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final user = AppUser(
      id: 1,
      fullName: 'Elena Marsh',
      email: 'elena@example.com',
      createdAt: DateTime(2026),
    );
    final repository = FakeAuthRepository(signedIn: user);
    await tester.pumpWidget(
      ModooApp(
        authRepository: repository,
        outfitRepository: FakeOutfitRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('PROFILE'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('142'), findsOneWidget);

    await tester.tap(find.text('EDIT IDENTITY'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Elena Rostova');
    await tester.tap(find.text('SAVE IDENTITY'));
    await tester.pumpAndSettle();

    expect(find.text('ELENA ROSTOVA'), findsOneWidget);
    expect(
      repository.currentUser(),
      completion(
        isA<AppUser>().having((user) => user.fullName, 'name', 'Elena Rostova'),
      ),
    );
  });
}
