import 'package:flutter_test/flutter_test.dart';
import 'package:miniproject_resume/main.dart';

void main() {
  testWidgets('Digital Business Card smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalBusinessCardApp());

    // Verify that the candidate name and job title are rendered.
    expect(find.text('linhdontcare'), findsOneWidget);
    expect(find.text('SENIOR FLUTTER DEVELOPER'), findsOneWidget);
  });
}
