import 'package:flutter_test/flutter_test.dart';

import 'package:tsl_mobile_app/main.dart';

void main() {
  testWidgets('Home screen renders key actions', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ابدأ التسجيل'), findsOneWidget);
    expect(find.text('السجل'), findsOneWidget);
  });
}
