import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modoo/features/auth/models/app_user.dart';
import 'package:modoo/main.dart';

import 'fake_auth_repository.dart';

final _elena = AppUser(
  id: 1,
  fullName: 'Elena Marsh',
  email: 'elena@example.com',
  createdAt: DateTime(2026),
);

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Signed-out user sees login; register lands on home',
      (tester) async {
    _phoneSize(tester);
    await tester.pumpWidget(ModooApp(authRepository: FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('WELCOME BACK'), findsOneWidget);
    await tester.tap(find.text('CREATE ONE'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Kaleb Test');
    await tester.enterText(find.byType(TextFormField).at(1), 'k@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(3), 'secret124');
    await tester.tap(find.text('CREATE ACCOUNT').last);
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(3), 'secret123');
    await tester.tap(find.text('CREATE ACCOUNT').last);
    await tester.pumpAndSettle();

    expect(find.text('WELCOME BACK,\nKALEB'), findsOneWidget);
  });

  testWidgets('Wrong password shows an error', (tester) async {
    _phoneSize(tester);
    final repo = FakeAuthRepository(signedIn: _elena);
    await repo.signOut();
    await tester.pumpWidget(ModooApp(authRepository: repo));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'elena@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
    await tester.tap(find.text('SIGN IN'));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect email or password.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('SIGN IN'));
    await tester.pumpAndSettle();
    expect(find.text('WELCOME BACK,\nELENA'), findsOneWidget);
  });

  testWidgets('Home bottom nav switches tabs and sign out returns to login',
      (tester) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      ModooApp(authRepository: FakeAuthRepository(signedIn: _elena)),
    );
    await tester.pumpAndSettle();
    expect(find.text('WELCOME BACK,\nELENA'), findsOneWidget);

    await tester.tap(find.text('WARDROBE').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Arrives with the clothing catalogue'),
        findsOneWidget);

    await tester.tap(find.text('PROFILE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SIGN OUT'));
    await tester.pumpAndSettle();
    expect(find.text('WELCOME BACK'), findsOneWidget);
  });

  testWidgets('Favourite toggle flips the icon', (tester) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      ModooApp(authRepository: FakeAuthRepository(signedIn: _elena)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byIcon(Icons.favorite_border_rounded).first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });
}
