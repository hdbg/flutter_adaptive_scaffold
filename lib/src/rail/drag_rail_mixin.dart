import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/src/rail/navrail.dart';

/// Mixin that provides shared drag/animation/state logic for drag rail variants.
///
/// Subclasses must implement [build] and can access all shared state
/// through the properties and methods provided by this mixin.
mixin DragRailStateMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController animationController;
  late Animation<double> widthAnimation;

  bool isExtended = false;
  bool isDragging = false;
  double dragProgress = 0.0;

  // Subclasses must provide these from their widget
  List<NavigationRailDestination> get destinations;
  double get collapsedWidth;
  double get expandedWidth;
  int? get selectedIndex;
  bool get extendedInitial;
  Color? get backgroundColor;
  EdgeInsetsGeometry get padding;
  Widget? get leadingExtended;
  Widget? get leadingCollapsed;
  Widget? get trailing;
  void Function(int)? get onDestinationSelected;
  void Function(bool)? get onExtendedChanged;
  double? get groupAlignment;
  IconThemeData? get selectedIconTheme;
  IconThemeData? get unselectedIconTheme;
  TextStyle? get selectedLabelTextStyle;
  TextStyle? get unSelectedLabelTextStyle;
  NavigationRailLabelType? get labelType;
  double get snapThreshold;

  double get widthRange => expandedWidth - collapsedWidth;

  double get expandProgress {
    if (isDragging) return dragProgress;
    return widthAnimation.value;
  }

  double get currentWidth {
    return collapsedWidth + (widthRange * expandProgress);
  }

  void initDragRailState() {
    isExtended = extendedInitial;
    animationController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: extendedInitial ? 1.0 : 0.0,
    );
    animationController.addListener(onAnimationTick);
    widthAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOut,
    );
  }

  void disposeDragRailState() {
    animationController.dispose();
  }

  void onAnimationTick() {
    setState(() {});
  }

  void setExtended(bool extended, {bool notify = true}) {
    if (isExtended == extended) return;

    setState(() {
      isExtended = extended;
    });

    if (extended) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    if (notify) {
      onExtendedChanged?.call(extended);
    }
  }

  void toggleExtended() {
    setExtended(!isExtended);
  }

  void onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
      dragProgress = isExtended ? 1.0 : 0.0;
    });
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!isDragging) return;

    setState(() {
      final delta = details.delta.dx / widthRange;
      dragProgress = (dragProgress + delta).clamp(0.0, 1.0);
    });
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (!isDragging) return;

    final shouldExpand = dragProgress >= snapThreshold;

    animationController.value = dragProgress;

    setState(() {
      isDragging = false;
    });

    if (shouldExpand) {
      animationController.forward();
      if (!isExtended) {
        isExtended = true;
        onExtendedChanged?.call(true);
      }
    } else {
      animationController.reverse();
      if (isExtended) {
        isExtended = false;
        onExtendedChanged?.call(false);
      }
    }
  }

  Widget buildNavRail({
    required bool showExtendedLabels,
    bool showLeadingTrailing = true,
  }) {
    final resolvedBackgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.surfaceDim;

    return IntrinsicHeight(
      child: ControllableNavRail(
        minWidth: collapsedWidth,
        minExtendedWidth: expandedWidth,
        labelType: labelType,
        leading: showLeadingTrailing
            ? (showExtendedLabels ? leadingExtended : leadingCollapsed)
            : null,
        trailing: showLeadingTrailing ? trailing : null,
        onDestinationSelected: onDestinationSelected,
        groupAlignment: groupAlignment,
        backgroundColor: resolvedBackgroundColor,
        extended: showExtendedLabels,
        extendedController: animationController,
        selectedIndex: selectedIndex,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: unselectedIconTheme,
        selectedLabelTextStyle: selectedLabelTextStyle,
        unselectedLabelTextStyle: unSelectedLabelTextStyle,
        destinations: destinations,
        scrollable: false,
      ),
    );
  }
}
