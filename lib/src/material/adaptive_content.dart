import 'package:flutter/material.dart';

import '../adaptive_layout.dart';
import 'material_breakpoints.dart';

/// A breakpoint-aware content widget for use inside [AdaptiveScaffold.body].
///
/// [AdaptiveContent] owns the split-pane content behavior that used to live in
/// [AdaptiveScaffold], including optional secondary content, body ratio, and
/// the built-in content transitions.
class AdaptiveContent extends StatelessWidget {
  const AdaptiveContent({
    super.key,
    required this.body,
    this.secondaryBody,
    this.bodyRatio,
    this.breakpoints = const MaterialAdaptiveBreakpoints(),
    this.internalAnimations = true,
    this.transitionDuration = const Duration(seconds: 1),
    this.bodyOrientation = Axis.horizontal,
  });

  /// Breakpoint-aware builders for the primary content slot.
  final MaterialSlotBuilders body;

  /// Breakpoint-aware builders for the optional secondary content slot.
  final MaterialSlotBuilders? secondaryBody;

  /// Defines the fractional ratio of [body] to the [secondaryBody].
  final double? bodyRatio;

  /// Breakpoints used to resolve the active content builders.
  final MaterialAdaptiveBreakpoints breakpoints;

  /// Whether the built-in content transitions are enabled.
  final bool internalAnimations;

  /// Duration used for content layout transitions.
  final Duration transitionDuration;

  /// The orientation of the body and secondaryBody.
  final Axis bodyOrientation;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      transitionDuration: transitionDuration,
      bodyOrientation: bodyOrientation,
      bodyRatio: bodyRatio,
      internalAnimations: internalAnimations,
      body: body.toSlotLayout(breakpoints, prefix: 'body'),
      secondaryBody: secondaryBody?.toSlotLayout(
        breakpoints,
        prefix: 'secondaryBody',
      ),
    );
  }
}
