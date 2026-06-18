import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hearth/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    // Force real repaint frames after the surface swap so freshly pushed
    // routes are fully laid out and painted before capture.
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 180));
    }
    await binding.takeScreenshot(name);
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  Future<void> tapText(WidgetTester tester, String text, {int index = 0}) async {
    final f = find.text(text);
    await tester.tap(index == 0 ? f.first : f.at(index));
    await settle(tester);
  }

  // Scroll the primary list until [text] is on-screen, then tap it.
  Future<void> tapScrolled(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.textContaining(text),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    await tester.tap(find.textContaining(text).first);
    await settle(tester);
  }

  testWidgets('Hearth full walkthrough screenshots', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HearthApp()));
    await settle(tester);

    // 1. Welcome / onboarding
    await shot(tester, '01-welcome');

    // 2. Identity verification
    await tapText(tester, 'Continue with email');
    await tapText(tester, 'Scan your photo ID');
    await tapText(tester, 'Quick selfie match');
    await shot(tester, '02-verify');

    // 3. Discover feed
    await tapText(tester, 'Start exploring');
    await shot(tester, '03-discover');

    // 4. Search results
    await tapText(tester, 'Search');
    await shot(tester, '04-search');

    // 5. Filter sheet
    await tester.tap(find.textContaining('Filters -').first);
    await settle(tester);
    await shot(tester, '05-filters');
    await tester.tap(find.textContaining('Show').first); // "Show N results" closes sheet
    await settle(tester);

    // 6. Messaging - thread list then conversation (from the shell)
    await tapText(tester, 'Messages');
    await tapText(tester, 'Maya Rivera');
    await shot(tester, '09-conversation');
    await tester.pageBack(); // conversation -> messages list
    await settle(tester);

    // 7. Profile & reviews
    await tapText(tester, 'Profile');
    await shot(tester, '10-profile');

    // 8. Admin & moderation
    await tapScrolled(tester, 'Admin & moderation');
    await shot(tester, '11-admin');
    await tester.pageBack(); // admin -> profile
    await settle(tester);

    // 9. Listing detail (Maya is featured on Discover) - done last so no unwind needed
    await tapText(tester, 'Discover');
    await tapText(tester, 'Maya Rivera');
    await shot(tester, '06-listing');

    // 10. Booking - date & time
    await tapScrolled(tester, 'Check availability');
    await shot(tester, '07-booking');

    // 11. Confirm & pay
    await tapScrolled(tester, 'Continue to payment');
    await shot(tester, '08-payment');
  });
}
