import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/outfits/controllers/outfits_controller.dart';
import 'package:modoo/features/studio/controllers/studio_controller.dart';
import 'package:modoo/features/studio/models/studio_garment.dart';
import 'package:modoo/features/studio/screens/studio_screen.dart';
import 'package:provider/provider.dart';

import 'fake_outfit_repository.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<(StudioController, FakeOutfitRepository)> _pumpStudio(
  WidgetTester tester,
) async {
  final repository = FakeOutfitRepository();
  final outfits = OutfitsController(repository);
  await outfits.bindUser(1);
  final studio = StudioController();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: outfits),
        ChangeNotifierProvider.value(value: studio),
      ],
      child: const MaterialApp(home: Scaffold(body: StudioScreen())),
    ),
  );
  return (studio, repository);
}

void main() {
  testWidgets('Studio controls update local preview selections', (
    tester,
  ) async {
    _phoneSize(tester);
    await _pumpStudio(tester);

    expect(find.text('PREVIEW ONLY · UNITY OFFLINE'), findsOneWidget);
    expect(find.text('FEM [AURA] · FRONT'), findsOneWidget);

    await tester.tap(find.text('SIDE'));
    await tester.pump();
    expect(find.text('FEM [AURA] · SIDE'), findsOneWidget);

    await tester.tap(find.text('MASC [KAI]'));
    await tester.pump();
    expect(find.text('MASC [KAI] · SIDE'), findsOneWidget);

    await tester.tap(find.byTooltip('Zoom in'));
    await tester.pump();
    expect(find.text('110%'), findsOneWidget);

    await tester.ensureVisible(find.text('BOTTOMS [3]'));
    await tester.tap(find.text('BOTTOMS [3]'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('WIDE SLACKS'));
    await tester.tap(find.text('WIDE SLACKS'));
    await tester.pumpAndSettle();
    expect(find.text('BTM: WIDE SLACKS'), findsOneWidget);
    expect(find.text('WORN'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Wide Slacks'));
    await tester.pumpAndSettle();
    expect(find.text('BTM: WIDE SLACKS'), findsNothing);

    await tester.ensureVisible(find.text('RESET LOOK'));
    await tester.tap(find.text('RESET LOOK'));
    await tester.pump();
    expect(find.text('BTM: CARGO SLACKS'), findsOneWidget);
  });

  testWidgets('Save outfit stores the mounted garments', (tester) async {
    _phoneSize(tester);
    final (studio, repository) = await _pumpStudio(tester);

    await tester.ensureVisible(find.text('SAVE OUTFIT'));
    await tester.tap(find.text('SAVE OUTFIT'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Night Shift');
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    expect(repository.all.single.name, 'Night Shift');
    expect(repository.all.single.avatarId, 'AURA');
    expect(repository.all.single.garmentIds, {
      StudioGarmentSlot.outerwear: 'leather-shacket',
      StudioGarmentSlot.top: 'crop-knit',
      StudioGarmentSlot.bottom: 'cargo-slacks',
    });
    expect(studio.editing?.name, 'Night Shift');
    expect(find.text('EDITING: NIGHT SHIFT'), findsOneWidget);

    // Saving again offers to update the open outfit in place.
    studio.remove(StudioGarmentSlot.outerwear);
    await tester.pump();
    await tester.tap(find.text('SAVE OUTFIT'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UPDATE'));
    await tester.pumpAndSettle();

    expect(repository.all, hasLength(1));
    expect(
      repository.all.single.garmentIds.containsKey(StudioGarmentSlot.outerwear),
      isFalse,
    );
  });

  testWidgets('Save is refused when nothing is mounted', (tester) async {
    _phoneSize(tester);
    final (studio, repository) = await _pumpStudio(tester);
    studio.startNewEnsemble();
    await tester.pump();

    await tester.ensureVisible(find.text('SAVE OUTFIT'));
    await tester.tap(find.text('SAVE OUTFIT'));
    await tester.pump();

    expect(find.text('Mount at least one garment before saving.'), findsOne);
    expect(repository.all, isEmpty);
  });
}
