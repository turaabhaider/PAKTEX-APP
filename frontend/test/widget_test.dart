import 'package:flutter_test/flutter_test.dart';
import 'package:paktex/main.dart';

void main() {
  testWidgets('Paktex app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PaktexApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}