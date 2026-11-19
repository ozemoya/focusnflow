import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnflow/main.dart';

void main() {
  testWidgets(
    'all six planned screens are reachable without claiming cloud data',
    (tester) async {
      await tester.pumpWidget(const FocusNFlowApp());
      expect(
        find.textContaining('cloud services are not connected'),
        findsOneWidget,
      );
      for (final name in sections.keys.where((name) => name != 'Today')) {
        await tester.ensureVisible(find.widgetWithText(ListTile, name));
        await tester.tap(find.widgetWithText(ListTile, name));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('No records have been created.'),
          findsOneWidget,
        );
        await tester.tap(find.text('Back to Today'));
        await tester.pumpAndSettle();
      }
    },
  );
}
