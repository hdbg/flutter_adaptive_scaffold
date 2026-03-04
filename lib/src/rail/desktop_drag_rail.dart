import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_adaptive_scaffold/src/rail/drag_rail_mixin.dart';

/// A drag rail variant for desktop breakpoints that pushes content aside
/// when expanded, with click-to-expand and click-to-collapse support.
class DesktopDragRail extends StatefulWidget {
  final List<NavigationRailDestination> destinations;
  final double collapsedWidth;
  final double expandedWidth;
  final int? selectedIndex;
  final bool extended;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final Widget? leadingExtended;
  final Widget? leadingCollapsed;
  final Widget? trailing;
  final void Function(int)? onDestinationSelected;
  final void Function(bool)? onExtendedChanged;
  final double? groupAlignment;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelTextStyle;
  final TextStyle? unSelectedLabelTextStyle;
  final NavigationRailLabelType? labelType;

  /// Threshold (0.0 to 1.0) at which the rail snaps to expanded/collapsed state.
  final double snapThreshold;

  const DesktopDragRail({
    super.key,
    required this.destinations,
    this.collapsedWidth = 72,
    this.expandedWidth = 200,
    this.selectedIndex,
    this.extended = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(kNavigationRailDefaultPadding),
    this.leadingExtended,
    this.leadingCollapsed,
    this.trailing,
    this.onDestinationSelected,
    this.onExtendedChanged,
    this.groupAlignment,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelTextStyle,
    this.unSelectedLabelTextStyle,
    this.labelType = NavigationRailLabelType.none,
    this.snapThreshold = 0.8,
  });

  @override
  State<DesktopDragRail> createState() => _DesktopDragRailState();
}

class _DesktopDragRailState extends State<DesktopDragRail>
    with SingleTickerProviderStateMixin, DragRailStateMixin {
  // DragRailStateMixin property implementations
  @override
  List<NavigationRailDestination> get destinations => widget.destinations;
  @override
  double get collapsedWidth => widget.collapsedWidth;
  @override
  double get expandedWidth => widget.expandedWidth;
  @override
  int? get selectedIndex => widget.selectedIndex;
  @override
  bool get extendedInitial => widget.extended;
  @override
  Color? get backgroundColor => widget.backgroundColor;
  @override
  EdgeInsetsGeometry get padding => widget.padding;
  @override
  Widget? get leadingExtended => widget.leadingExtended;
  @override
  Widget? get leadingCollapsed => widget.leadingCollapsed;
  @override
  Widget? get trailing => widget.trailing;
  @override
  void Function(int)? get onDestinationSelected =>
      widget.onDestinationSelected;
  @override
  void Function(bool)? get onExtendedChanged => widget.onExtendedChanged;
  @override
  double? get groupAlignment => widget.groupAlignment;
  @override
  IconThemeData? get selectedIconTheme => widget.selectedIconTheme;
  @override
  IconThemeData? get unselectedIconTheme => widget.unselectedIconTheme;
  @override
  TextStyle? get selectedLabelTextStyle => widget.selectedLabelTextStyle;
  @override
  TextStyle? get unSelectedLabelTextStyle => widget.unSelectedLabelTextStyle;
  @override
  NavigationRailLabelType? get labelType => widget.labelType;
  @override
  double get snapThreshold => widget.snapThreshold;

  @override
  void initState() {
    super.initState();
    initDragRailState();
  }

  @override
  void didUpdateWidget(DesktopDragRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.extended != widget.extended && !isDragging) {
      setExtended(widget.extended, notify: false);
    }
  }

  @override
  void dispose() {
    disposeDragRailState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showExtendedLabels =
        isDragging ? dragProgress >= snapThreshold : isExtended;

    final screenHeight = MediaQuery.sizeOf(context).height;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      child: SizedBox(
        width: currentWidth,
        height: screenHeight,
        child: GestureDetector(
          onTap: toggleExtended,
          onHorizontalDragStart: onHorizontalDragStart,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onHorizontalDragEnd: onHorizontalDragEnd,
          behavior: HitTestBehavior.opaque,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                child:
                    buildNavRail(showExtendedLabels: showExtendedLabels),
              );
            },
          ),
        ),
      ),
    );
  }
}
