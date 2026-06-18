import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hearth/main.dart';

void main() {
  testWidgets('Welcome screen renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HearthApp()));
    expect(find.text('Hearth'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
  });
}
