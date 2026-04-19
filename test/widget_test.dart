import 'package:flutter_test/flutter_test.dart';
import 'package:hostel_managemet/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: HostelApp()));

    // Verify that login screen is shown (mock check)
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
