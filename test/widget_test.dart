// Student: Farah Alhasan
// Student Number: 21120205709

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:user_profile_app/main.dart';

void main() {
  // Phone-sized screen so the bottom navigation bar is used.
  void usePhoneScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('Profile loads, then the message dialog can be sent', (
    WidgetTester tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const MyApp());

    // Loading state first
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('M Sinan'), findsOneWidget);
    expect(find.text('Refresh User'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);

    // Open the dialog
    await tester.tap(find.text('Send Message'));
    await tester.pumpAndSettle();
    expect(find.text('New Message'), findsOneWidget);
    expect(find.text('To: M Sinan'), findsOneWidget);

    // Empty form shows validation errors
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Please enter a subject'), findsOneWidget);

    // Switch to e-mail mode
    await tester.tap(find.byIcon(Icons.alternate_email));
    await tester.pump();
    expect(find.text('New E-mail'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Subject'),
      'Homework',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'Hello, I have a question about week 5.',
    );
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Sending...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('New E-mail'), findsNothing);
    expect(find.text('E-mail sent to M Sinan.'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens every page', (
    WidgetTester tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();
    expect(find.text('Biography'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.flag_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Our Mission'), findsOneWidget);
    expect(find.text('Our Vision'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.contact_mail_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Office Hours'), findsOneWidget);

    await tester.ensureVisible(find.text('Send Instant Message'));
    await tester.tap(find.text('Send Instant Message'));
    await tester.pumpAndSettle();
    expect(find.text('New Message'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('New Message'), findsNothing);
  });

  testWidgets('Side menu navigates to a page', (WidgetTester tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationDrawer),
        matching: find.text('Mission'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Our Mission'), findsOneWidget);
    expect(find.byType(NavigationDrawer), findsNothing);
  });

  testWidgets('Wide screens use a navigation rail', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
