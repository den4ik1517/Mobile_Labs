import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LogisticsApp());

    // Verify that the login page is displayed initially.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // Tap the 'Register' button and trigger a frame.
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify that the register page is displayed.
    expect(find.text('Register'), findsOneWidget);

    // Tap the 'Register' button again to navigate to the profile.
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify that profile page is displayed.
    expect(find.text('Profile'), findsOneWidget);
  });
}
