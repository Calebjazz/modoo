import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/studio/screens/studio_screen.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Studio controls update local preview selections', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StudioScreen())),
    );

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

    await tester.ensureVisible(find.text('BOTTOMS'));
    await tester.tap(find.text('BOTTOMS'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('WIDE SLACKS'));
    await tester.tap(find.text('WIDE SLACKS'));
    await tester.pumpAndSettle();
    expect(find.text('BTM: WIDE SLACKS'), findsOneWidget);

    await tester.ensureVisible(find.text('RESET LOOK'));
    await tester.tap(find.text('RESET LOOK'));
    await tester.pump();
    expect(find.text('BTM: CARGO SLACKS'), findsOneWidget);
  });

  testWidgets('Save explains that outfit persistence is not available', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StudioScreen())),
    );

    await tester.ensureVisible(find.text('SAVE OUTFIT'));
    await tester.tap(find.text('SAVE OUTFIT'));
    await tester.pump();

    expect(
      find.textContaining('until outfit storage is implemented'),
      findsOneWidget,
    );
  });
}
