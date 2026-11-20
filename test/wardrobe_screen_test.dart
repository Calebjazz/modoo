import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/wardrobe/screens/wardrobe_screen.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2910);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Wardrobe categories and search filter the local catalog', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WardrobeScreen())),
    );

    expect(find.text('DIGITAL\nWARDROBE'), findsOneWidget);
    expect(find.text('ALL (06)'), findsOneWidget);

    await tester.tap(find.text('BOTTOMS (02)'));
    await tester.pumpAndSettle();
    expect(find.text('CARGO TROUSER'), findsOneWidget);
    expect(find.text('WRAP MIDI SKIRT'), findsOneWidget);
    expect(find.text('ARCHITECTURAL OVERCOAT'), findsNothing);

    await tester.enterText(find.byType(TextField), 'sunglasses');
    await tester.pumpAndSettle();
    expect(find.text('WIRE SUNGLASSES'), findsNothing);
    expect(find.text('NO PIECES MATCH YOUR SEARCH'), findsOneWidget);
  });

  testWidgets('Material filter and look selection update the page state', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WardrobeScreen())),
    );

    await tester.tap(find.text('FILTERS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HEAVY WOOL'));
    await tester.tap(find.text('APPLY FILTERS'));
    await tester.pumpAndSettle();
    expect(find.text('FILTERS (1)'), findsOneWidget);
    expect(find.text('ARCHITECTURAL OVERCOAT'), findsOneWidget);
    expect(find.text('CARGO TROUSER'), findsNothing);

    await tester.ensureVisible(find.text('ARCHITECTURAL OVERCOAT'));
    await tester.tap(
      find.bySemanticsLabel('Add Architectural Overcoat to look'),
    );
    await tester.pump();
    expect(find.textContaining('1 PIECE SELECTED'), findsOneWidget);
  });
}
