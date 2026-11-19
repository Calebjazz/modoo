import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/avatars/screens/avatar_customization_screen.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2910);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Customization selections update and can be reset', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      const MaterialApp(home: AvatarCustomizationScreen()),
    );

    expect(find.text('ACTIVE: FEMALE [AURA]'), findsOneWidget);
    expect(find.text('UNITY VIEWPORT NOT CONNECTED · AURA'), findsOneWidget);

    await tester.tap(find.text('MALE [KAI]'));
    await tester.pump();
    expect(find.text('ACTIVE: MALE [KAI]'), findsOneWidget);

    await tester.tap(find.byTooltip('Umber'));
    await tester.pump();
    expect(find.text('TONE #05 (UMBER)'), findsOneWidget);

    await tester.ensureVisible(find.text('PROPORTION'));
    await tester.tap(find.text('PROPORTION'));
    await tester.pump();
    expect(find.text('HEIGHT'), findsOneWidget);
    expect(find.text('178 CM'), findsOneWidget);

    await tester.ensureVisible(find.text('RESET TO ATELIER DEFAULT'));
    await tester.tap(find.text('RESET TO ATELIER DEFAULT'));
    await tester.pump();
    expect(find.text('ACTIVE: FEMALE [AURA]'), findsOneWidget);
  });

  testWidgets('Applying changes reports Unity integration is pending', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      const MaterialApp(home: AvatarCustomizationScreen()),
    );

    await tester.ensureVisible(find.text('APPLY TO STUDIO VIEWPORT'));
    await tester.tap(find.text('APPLY TO STUDIO VIEWPORT'));
    await tester.pump();

    expect(
      find.text('Avatar changes cannot be applied until Unity is connected.'),
      findsOneWidget,
    );
  });
}
