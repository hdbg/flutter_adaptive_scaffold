# flutter_adaptive_scaffold

Community-maintained fork of the Flutter team's `flutter_adaptive_scaffold` package, which was [discontinued in 2024](https://github.com/flutter/flutter/issues/162965).

This package helps you build responsive Material layouts that switch navigation and content structure across compact, medium, and large breakpoints.

## Installation

Add the dependency:

```yaml
dependencies:
  flutter_adaptive_scaffold: ^0.3.3+1
```

Then import it:

```dart
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
```

## What this package provides

- `AdaptiveScaffold` for a higher-level adaptive Material shell
- `AdaptiveLayout` and `SlotLayout` for lower-level custom layouts
- `Breakpoint` and `Breakpoints` helpers
- `MaterialSlotBuilders` and `MaterialAdaptiveBreakpoints` for configuring `AdaptiveScaffold`

## Quick start

The current `AdaptiveScaffold` API groups body builders into `MaterialSlotBuilders`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const InboxScreen(),
    );
  }
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int _selectedIndex = 0;

  static const List<NavigationDestination> _destinations =
      <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.inbox_outlined),
          selectedIcon: Icon(Icons.inbox),
          label: 'Inbox',
        ),
        NavigationDestination(
          icon: Icon(Icons.send_outlined),
          selectedIcon: Icon(Icons.send),
          label: 'Sent',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: _destinations,
      body: MaterialSlotBuilders(
        smallBody: (_) => const _MessageList(compact: true),
        body: (_) => const _MessageList(),
        mediumLargeBody: (_) => const _MessageList(),
        largeBody: (_) => const _MessageList(),
        extraLargeBody: (_) => const _MessageList(),
      ),
      secondaryBody: MaterialSlotBuilders(
        body: (_) => const _MessageDetail(),
        mediumLargeBody: (_) => const _MessageDetail(),
        largeBody: (_) => const _MessageDetail(),
        extraLargeBody: (_) => const _MessageDetail(),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(compact ? 12 : 24),
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.mail_outline)),
          title: Text('Message #$index'),
          subtitle: const Text('AdaptiveScaffold body content'),
        );
      },
    );
  }
}

class _MessageDetail extends StatelessWidget {
  const _MessageDetail();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Select a message'),
    );
  }
}
```

## How `AdaptiveScaffold` works

`AdaptiveScaffold` chooses different navigation patterns by breakpoint:

- `small`: bottom navigation by default
- `small` desktop with `useDrawer: true`: drawer
- `medium`: overlay drag rail
- `mediumLarge` and above: desktop drag rail

For content, `body` and `secondaryBody` are defined with `MaterialSlotBuilders`.
Each property is independent:

- `smallBody`
- `body` for the medium breakpoint
- `mediumLargeBody`
- `largeBody`
- `extraLargeBody`

This fork does not make `smallBody` fall back to `body`. If you want the same widget on multiple breakpoints, provide builders for each breakpoint you want to support.

## Custom breakpoints

You can override the breakpoint set used by `AdaptiveScaffold`:

```dart
AdaptiveScaffold(
  destinations: destinations,
  selectedIndex: selectedIndex,
  onSelectedIndexChange: onSelectedIndexChange,
  breakpoints: const MaterialAdaptiveBreakpoints(
    small: Breakpoints.small,
    medium: Breakpoints.medium,
    mediumLarge: Breakpoints.mediumLarge,
    large: Breakpoints.large,
    extraLarge: Breakpoints.extraLarge,
  ),
  body: MaterialSlotBuilders(
    smallBody: (_) => const SmallBody(),
    body: (_) => const MediumBody(),
  ),
)
```

## Common options

Useful `AdaptiveScaffold` parameters:

- `destinations`: navigation items
- `selectedIndex`: active destination index
- `onSelectedIndexChange`: navigation callback
- `body`: required `MaterialSlotBuilders`
- `secondaryBody`: optional secondary pane
- `bodyRatio`: width split between primary and secondary panes
- `appBar`: optional `PreferredSizeWidget`
- `drawerBreakpoint`: override when the drawer should be used
- `navigationRailWidth`: collapsed rail width
- `extendedNavigationRailWidth`: expanded rail width
- `internalAnimations`: enable or disable built-in transitions

## Changes from the original package

### Independent `smallBody` slot

`smallBody` no longer falls back to `body` when omitted. Each breakpoint slot is now fully independent.

### Draggable navigation rail

The navigation rail supports drag-to-expand/collapse and tap-to-toggle. Two variants are provided:

- `OverlayDragRail`: for medium breakpoints. The expanded rail renders as an overlay with a scrim, without pushing body content aside.
- `DesktopDragRail`: for large breakpoints. The expanded rail pushes body content aside.

`AdaptiveScaffold` uses:

- `OverlayDragRail` at the medium breakpoint
- `DesktopDragRail` at `mediumLarge` and above

Both widgets are also available for direct use in custom `AdaptiveLayout` configurations.

## Example app

A runnable sample app lives in [example/](/Users/kaska/Documents/Projects/Major/flutter_adaptive_scaffold/example). It demonstrates:

- multiple navigation tabs
- `MaterialSlotBuilders`-based configuration
- a secondary pane on larger layouts

Run it with:

```bash
cd example
flutter run
```

## Lower-level APIs

Use these if you need more control than `AdaptiveScaffold` provides:

- `AdaptiveLayout`
- `SlotLayout`
- `SlotLayout.from`
- `Breakpoint`
- `Breakpoints`

These let you compose your own breakpoint-aware layout and animations while still using the package's adaptive primitives.

## License

BSD 3-Clause. See [LICENSE](LICENSE).
