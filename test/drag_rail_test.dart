// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/src/rail/desktop_drag_rail.dart';
import 'package:flutter_adaptive_scaffold/src/rail/overlay_drag_rail.dart';
import 'package:flutter_test/flutter_test.dart';

const List<NavigationRailDestination> _destinations =
    <NavigationRailDestination>[
  NavigationRailDestination(
    icon: Icon(Icons.home),
    label: Text('Home'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.account_circle),
    label: Text('Profile'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text('Settings'),
  ),
];

/// Builds a test scaffold with an OverlayDragRail and a body side by side.
Widget _buildOverlayTestApp({
  bool extended = false,
  double collapsedWidth = 72,
  double expandedWidth = 200,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  ValueChanged<bool>? onExtendedChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Row(
        children: [
          OverlayDragRail(
            destinations: _destinations,
            collapsedWidth: collapsedWidth,
            expandedWidth: expandedWidth,
            extended: extended,
            onExtendedChanged: onExtendedChanged,
            padding: padding,
          ),
          const Expanded(
            child: ColoredBox(
              key: Key('body'),
              color: Colors.white,
              child: SizedBox.expand(),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Builds a test scaffold with a DesktopDragRail and a body side by side.
Widget _buildDesktopTestApp({
  bool extended = false,
  double collapsedWidth = 72,
  double expandedWidth = 200,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  ValueChanged<bool>? onExtendedChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Row(
        children: [
          DesktopDragRail(
            destinations: _destinations,
            collapsedWidth: collapsedWidth,
            expandedWidth: expandedWidth,
            extended: extended,
            onExtendedChanged: onExtendedChanged,
            padding: padding,
          ),
          const Expanded(
            child: ColoredBox(
              key: Key('body'),
              color: Colors.white,
              child: SizedBox.expand(),
            ),
          ),
        ],
      ),
    ),
  );
}

void main() {
  group('OverlayDragRail', () {
    testWidgets(
      'always consumes collapsed width for layout',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildOverlayTestApp(extended: false));
        await tester.pumpAndSettle();

        final dragRail = find.byType(OverlayDragRail);
        expect(dragRail, findsOneWidget);
        expect(tester.getSize(dragRail).width, equals(72.0));
      },
    );

    testWidgets(
      'consumes collapsed width even when extended',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildOverlayTestApp(extended: true));
        await tester.pumpAndSettle();

        final dragRail = find.byType(OverlayDragRail);
        expect(tester.getSize(dragRail).width, equals(72.0));
      },
    );

    testWidgets(
      'body gets same space regardless of extension',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));

        await tester.pumpWidget(_buildOverlayTestApp(extended: false));
        await tester.pumpAndSettle();
        final bodyCollapsedWidth =
            tester.getSize(find.byKey(const Key('body'))).width;

        await tester.pumpWidget(_buildOverlayTestApp(extended: true));
        await tester.pumpAndSettle();
        final bodyExtendedWidth =
            tester.getSize(find.byKey(const Key('body'))).width;

        expect(bodyCollapsedWidth, equals(bodyExtendedWidth));

        await tester.binding.setSurfaceSize(const Size(800, 600));
      },
    );

    testWidgets(
      'scrim appears when expanded',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildOverlayTestApp(extended: true));
        await tester.pumpAndSettle();

        final scrimFinder = find.byWidgetPredicate((Widget widget) {
          if (widget is ColoredBox) {
            final color = widget.color;
            return color.r == 0 &&
                color.g == 0 &&
                color.b == 0 &&
                color.a > 0;
          }
          return false;
        });
        expect(scrimFinder, findsOneWidget);
      },
    );

    testWidgets(
      'tapping scrim collapses with animation',
      (WidgetTester tester) async {
        bool? lastExtendedValue;

        await tester.pumpWidget(_buildOverlayTestApp(
          extended: true,
          onExtendedChanged: (value) => lastExtendedValue = value,
        ));
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(600, 300));
        await tester.pump();
        expect(lastExtendedValue, isFalse);

        await tester.pumpAndSettle();
        final scrimFinder = find.byWidgetPredicate((Widget widget) {
          if (widget is ColoredBox) {
            final color = widget.color;
            return color.r == 0 &&
                color.g == 0 &&
                color.b == 0 &&
                color.a > 0;
          }
          return false;
        });
        expect(scrimFinder, findsNothing);
      },
    );

    testWidgets(
      'tapping collapsed rail expands it',
      (WidgetTester tester) async {
        bool? lastExtendedValue;

        await tester.pumpWidget(_buildOverlayTestApp(
          extended: false,
          onExtendedChanged: (value) => lastExtendedValue = value,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(OverlayDragRail));
        await tester.pumpAndSettle();

        expect(lastExtendedValue, isTrue);
      },
    );

    testWidgets(
      'overlay aligns to top-left when padding is present',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildOverlayTestApp(
          extended: true,
          padding: const EdgeInsets.all(16),
        ));
        await tester.pumpAndSettle();

        final follower = find.byType(CompositedTransformFollower);
        expect(follower, findsOneWidget);
        final topLeft = tester.getTopLeft(follower);
        expect(topLeft.dx, equals(0.0));
        expect(topLeft.dy, equals(0.0));
      },
    );
  });

  group('DesktopDragRail', () {
    testWidgets(
      'consumes collapsed width when collapsed',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildDesktopTestApp(extended: false));
        await tester.pumpAndSettle();

        final dragRail = find.byType(DesktopDragRail);
        expect(dragRail, findsOneWidget);
        expect(tester.getSize(dragRail).width, equals(72.0));
      },
    );

    testWidgets(
      'consumes expanded width when extended',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildDesktopTestApp(extended: true));
        await tester.pumpAndSettle();

        final dragRail = find.byType(DesktopDragRail);
        expect(dragRail, findsOneWidget);
        expect(tester.getSize(dragRail).width, equals(200.0));
      },
    );

    testWidgets(
      'body width changes when rail extends',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));

        await tester.pumpWidget(_buildDesktopTestApp(extended: false));
        await tester.pumpAndSettle();
        final bodyCollapsedWidth =
            tester.getSize(find.byKey(const Key('body'))).width;

        await tester.pumpWidget(_buildDesktopTestApp(extended: true));
        await tester.pumpAndSettle();
        final bodyExtendedWidth =
            tester.getSize(find.byKey(const Key('body'))).width;

        // Desktop rail pushes content aside, so body should be narrower
        expect(bodyExtendedWidth, lessThan(bodyCollapsedWidth));

        await tester.binding.setSurfaceSize(const Size(800, 600));
      },
    );

    testWidgets(
      'no scrim overlay when extended',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildDesktopTestApp(extended: true));
        await tester.pumpAndSettle();

        // No OverlayPortal or scrim in desktop variant
        final scrimFinder = find.byWidgetPredicate((Widget widget) {
          if (widget is ColoredBox) {
            final color = widget.color;
            return color.r == 0 &&
                color.g == 0 &&
                color.b == 0 &&
                color.a > 0;
          }
          return false;
        });
        expect(scrimFinder, findsNothing);
      },
    );

    testWidgets(
      'tapping collapsed rail expands it',
      (WidgetTester tester) async {
        bool? lastExtendedValue;

        await tester.pumpWidget(_buildDesktopTestApp(
          extended: false,
          onExtendedChanged: (value) => lastExtendedValue = value,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(DesktopDragRail));
        await tester.pumpAndSettle();

        expect(lastExtendedValue, isTrue);

        // Rail should now be at expanded width
        final dragRail = find.byType(DesktopDragRail);
        expect(tester.getSize(dragRail).width, equals(200.0));
      },
    );

    testWidgets(
      'tapping expanded rail collapses it',
      (WidgetTester tester) async {
        bool? lastExtendedValue;

        await tester.pumpWidget(_buildDesktopTestApp(
          extended: true,
          onExtendedChanged: (value) => lastExtendedValue = value,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(DesktopDragRail));
        await tester.pumpAndSettle();

        expect(lastExtendedValue, isFalse);

        // Rail should now be at collapsed width
        final dragRail = find.byType(DesktopDragRail);
        expect(tester.getSize(dragRail).width, equals(72.0));
      },
    );
  });
}

