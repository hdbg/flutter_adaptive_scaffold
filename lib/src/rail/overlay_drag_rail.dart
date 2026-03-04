import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_adaptive_scaffold/src/rail/drag_rail_mixin.dart';

/// A drag rail variant for smaller breakpoints that renders the expanded
/// portion as an overlay with a scrim, without consuming extra layout space.
class OverlayDragRail extends StatefulWidget {
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

  /// Maximum opacity of the scrim overlay when the rail is fully expanded.
  final double scrimMaxOpacity;

  /// Threshold (0.0 to 1.0) at which the rail snaps to expanded/collapsed state.
  final double snapThreshold;

  const OverlayDragRail({
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
    this.scrimMaxOpacity = 0.5,
    this.snapThreshold = 0.8,
  });

  @override
  State<OverlayDragRail> createState() => _OverlayDragRailState();
}

class _OverlayDragRailState extends State<OverlayDragRail>
    with SingleTickerProviderStateMixin, DragRailStateMixin {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

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
    animationController.addStatusListener(_onAnimationStatus);
    if (widget.extended) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(OverlayDragRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.extended != widget.extended && !isDragging) {
      _setExtendedOverlay(widget.extended, notify: false);
    }
  }

  @override
  void dispose() {
    disposeDragRailState();
    super.dispose();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !isDragging) {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (!_overlayController.isShowing) {
      _overlayController.show();
    }
  }

  void _hideOverlay() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
  }

  void _setExtendedOverlay(bool extended, {bool notify = true}) {
    if (isExtended == extended) return;

    setState(() {
      isExtended = extended;
    });

    if (extended) {
      _showOverlay();
      animationController.forward();
    } else {
      animationController.reverse();
    }

    if (notify) {
      onExtendedChanged?.call(extended);
    }
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    super.onHorizontalDragStart(details);
    _showOverlay();
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    super.onHorizontalDragEnd(details);
    // If the drag collapsed the rail and the animation already reached
    // dismissed (e.g. user dragged all the way closed), the status listener
    // would have skipped _hideOverlay because isDragging was still true at
    // that point. Ensure the overlay is cleaned up.
    if (!isExtended && animationController.isDismissed) {
      _hideOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showExtendedLabels =
        isDragging ? dragProgress >= snapThreshold : isExtended;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final overlayActive = _overlayController.isShowing;

    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (BuildContext context) {
          final progress = expandProgress;
          return Stack(
            children: [
              // Scrim: dims main content, tapping collapses the rail
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _setExtendedOverlay(false),
                  child: ColoredBox(
                    color: Colors.black.withValues(
                      alpha: widget.scrimMaxOpacity * progress,
                    ),
                  ),
                ),
              ),
              // Expanded rail positioned at the same location as the collapsed rail
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: SizedBox(
                    width: currentWidth,
                    height: screenHeight,
                    child: GestureDetector(
                      onHorizontalDragStart: onHorizontalDragStart,
                      onHorizontalDragUpdate: onHorizontalDragUpdate,
                      onHorizontalDragEnd: onHorizontalDragEnd,
                      behavior: HitTestBehavior.opaque,
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints constraints) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: buildNavRail(
                                showExtendedLabels: showExtendedLabels),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            width: collapsedWidth,
            height: screenHeight,
            child: GestureDetector(
              onTap: () => _setExtendedOverlay(true),
              onHorizontalDragStart: onHorizontalDragStart,
              onHorizontalDragUpdate: onHorizontalDragUpdate,
              onHorizontalDragEnd: onHorizontalDragEnd,
              behavior: HitTestBehavior.opaque,
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: buildNavRail(
                      showExtendedLabels: false,
                      showLeadingTrailing: !overlayActive,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
