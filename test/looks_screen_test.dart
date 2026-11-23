import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/auth/models/app_user.dart';
import 'package:modoo/features/studio/models/studio_garment.dart';
import 'package:modoo/main.dart';

import 'fake_auth_repository.dart';
import 'fake_outfit_repository.dart';

final _elena = AppUser(
  id: 1,
  fullName: 'Elena Marsh',
  email: 'elena@example.com',
  createdAt: DateTime(2026),
);

Future<FakeOutfitRepository> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final outfits = FakeOutfitRepository();
  await outfits.create(
    userId: 1,
    name: 'Night Shift',
    avatarId: 'KAI',
    garmentIds: {
      StudioGarmentSlot.top: 'cotton-jersey',
      StudioGarmentSlot.bottom: 'wide-slacks',
    },
  );
  await tester.pumpWidget(
    ModooApp(
      authRepository: FakeAuthRepository(signedIn: _elena),
      outfitRepository: outfits,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('LOOKS').last);
  await tester.pumpAndSettle();
  return outfits;
}

void main() {
  testWidgets('Looks lists saved outfits with the real count', (tester) async {
    await _pumpApp(tester);

    expect(find.text('SAVED LOOKS (1)'), findsOneWidget);
    expect(find.text('Night Shift'), findsOneWidget);
    expect(find.text('Cotton Jersey, Wide Slacks'), findsOneWidget);
    expect(find.text('NOV 23'), findsOneWidget);
    expect(find.text('Noir Tailoring'), findsOneWidget);
  });

  testWidgets('Studio View loads the outfit and its avatar', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('STUDIO VIEW').first);
    await tester.pumpAndSettle();

    expect(find.text('MASC [KAI] · FRONT'), findsOneWidget);
    expect(find.text('TOP: COTTON JERSEY'), findsOneWidget);
    expect(find.text('BTM: WIDE SLACKS'), findsOneWidget);
    expect(find.text('OUTER: LEATHER SHACKET'), findsNothing);
  });

  testWidgets('Rename and delete a saved outfit', (tester) async {
    final repository = await _pumpApp(tester);

    await tester.tap(find.byTooltip('More options').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Late Shift');
    await tester.tap(find.text('RENAME'));
    await tester.pumpAndSettle();
    expect(find.text('Late Shift'), findsOneWidget);
    expect(repository.all.single.name, 'Late Shift');

    await tester.tap(find.byTooltip('More options').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('DELETE'));
    await tester.pumpAndSettle();

    expect(repository.all, isEmpty);
    expect(find.text('SAVED LOOKS (0)'), findsOneWidget);
  });

  testWidgets('Avatar filter hides looks for other avatars', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byTooltip('Filter looks by avatar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aura (female)'));
    await tester.pumpAndSettle();

    expect(find.text('Night Shift'), findsNothing);
    expect(find.text('No saved looks for AURA.'), findsOneWidget);
  });
}
