import 'package:flutter_test/flutter_test.dart';
import 'package:resume_android/main.dart';

void main() {
  testWidgets('Digital Business Card smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalBusinessCardApp());

    // Verify profile information is rendered.
    expect(find.text('linhdontcare'), findsOneWidget);
    expect(find.text('SENIOR FLUTTER / ANDROID DEVELOPER'), findsOneWidget);
    expect(find.text('GitHub Profile'), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('Gửi Email'), findsOneWidget);
    expect(find.text('Gọi điện thoại'), findsOneWidget);
  });
}
