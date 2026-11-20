import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnflow/main.dart';

void main() {
  Future<void> open(WidgetTester tester, String page) async {
    await tester.tap(find.byKey(const Key('all-screens')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ValueKey('nav-$page')));
    await tester.tap(find.byKey(ValueKey('nav-$page')));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'six screens navigate, controls respond, and cloud state stays explicit',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const capture = bool.fromEnvironment('CAPTURE_UI');
      if (capture) {
        final dir = Platform.environment['FOCUS_FONT_DIR']!;
        final loader = FontLoader('Roboto');
        for (final name in [
          'roboto-regular.ttf',
          'roboto-bold.ttf',
          'roboto-black.ttf',
        ]) {
          loader.addFont(
            Future.value(
              ByteData.sublistView(File('$dir/$name').readAsBytesSync()),
            ),
          );
        }
        await loader.load();
        await (FontLoader('MaterialIcons')..addFont(
              Future.value(
                ByteData.sublistView(
                  File('$dir/materialicons-regular.otf').readAsBytesSync(),
                ),
              ),
            ))
            .load();
      }
      final imageKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: imageKey, child: const FocusNFlowApp()),
      );
      await tester.pumpAndSettle();
      for (final page in sections.keys) {
        await open(tester, page);
        expect(find.text('DESIGN PREVIEW · NOT CONNECTED'), findsOneWidget);
        expect(tester.takeException(), isNull, reason: page);
        if (capture) {
          await tester.runAsync(() async {
            final boundary =
                imageKey.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await boundary.toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final dir = Directory('preview-qa/ui');
            await dir.create(recursive: true);
            await File('${dir.path}/${page.toLowerCase()}.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      }
      await open(tester, 'Rooms');
      await tester.tap(find.text('Whiteboard'));
      await tester.pumpAndSettle();
      expect(find.text('The idea room'), findsOneWidget);
      expect(find.text('Occupancy unknown'), findsOneWidget);
      await open(tester, 'Focus');
      await tester.ensureVisible(find.text('45 min'));
      await tester.tap(find.text('45 min'));
      await tester.pumpAndSettle();
      expect(find.text('45:00'), findsOneWidget);
      expect(find.text('No shared session active'), findsOneWidget);
    },
  );
  testWidgets('small-screen navigation remains usable with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const FocusNFlowApp());
    for (final page in sections.keys) {
      await open(tester, page);
      expect(tester.takeException(), isNull, reason: page);
    }
  });
}
