import 'package:flutter_test/flutter_test.dart';

import 'package:investwatch/main.dart';

void main() {
  testWidgets('App boots and shows the dashboard navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const InvestWatchApp());
    await tester.pump();

    expect(find.text('Monitor'), findsWidgets);
    expect(find.text('Conversor'), findsWidgets);
    expect(find.text('Simulador'), findsWidgets);
  });

  testWidgets('Navigating to converter shows the currency form', (WidgetTester tester) async {
    await tester.pumpWidget(const InvestWatchApp());
    await tester.pump();

    await tester.tap(find.text('Conversor').first);
    await tester.pump();

    expect(find.text('Converter'), findsOneWidget);
  });
}
