import 'package:flutter_test/flutter_test.dart';

import 'package:demoresume/main.dart';

void main() {
  testWidgets('Profile screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileCardApp());

    expect(find.text('Linhdontcare'), findsOneWidget);
    expect(find.text('FLUTTER DEVELOPER'), findsOneWidget);
  });
}
