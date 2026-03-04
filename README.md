# flutter_adaptive_scaffold

Community-maintained fork of the Flutter team's `flutter_adaptive_scaffold` package, which was [discontinued in 2024](https://github.com/flutter/flutter/issues/162965).

## Changes from the original

### Independent `smallBody` slot

`smallBody` no longer falls back to `body` when omitted. Each breakpoint slot is now fully independent.

### Draggable navigation rail

The navigation rail supports drag-to-expand/collapse and tap-to-toggle. Two variants are provided:

- **`OverlayDragRail`** — for medium (tablet) breakpoints. The expanded rail renders as an overlay with a background scrim, without pushing body content aside.
- **`DesktopDragRail`** — for large (desktop) breakpoints. The expanded rail pushes body content aside.

`AdaptiveScaffold` uses `OverlayDragRail` at the medium breakpoint and `DesktopDragRail` at mediumLarge and above. Both widgets are also available for direct use in custom `AdaptiveLayout` configurations.

## License

BSD 3-Clause — see [LICENSE](LICENSE). Original package by the Flutter Authors.
