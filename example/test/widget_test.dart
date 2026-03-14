// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('renders adaptive workspace example', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Adaptive Workspace'), findsOneWidget);
    expect(find.text('Operations snapshot'), findsOneWidget);
    expect(find.text('Overview'), findsWidgets);

    await tester.tap(find.byIcon(Icons.inventory_2_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Today\'s shipping board'), findsOneWidget);
    expect(find.text('Ready to pack'), findsOneWidget);
  });
}
