import 'package:flutter/cupertino.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class MaterialBreakpoints {
  final Breakpoint small;
  final Breakpoint medium;
  final Breakpoint mediumLarge;
  final Breakpoint large;
  final Breakpoint extraLarge;

  const MaterialBreakpoints({
    this.small = Breakpoints.small,
    this.medium = Breakpoints.medium,
    this.mediumLarge = Breakpoints.mediumLarge,
    this.large = Breakpoints.large,
    this.extraLarge = Breakpoints.extraLarge,
  });
}

class MaterialBuilders {
  final WidgetBuilder? smallBody;
  final WidgetBuilder? body;
  final WidgetBuilder? mediumLargeBody;
  final WidgetBuilder? largeBody;
  final WidgetBuilder? extraLargeBody;

  const MaterialBuilders({
    this.smallBody,
    this.body,
    this.mediumLargeBody,
    this.largeBody,
    this.extraLargeBody,
  });

  SlotLayout toSlotLayout(
    MaterialBreakpoints breakpoints, {
    String prefix = '',
    Widget Function(Widget, Animation<double>)? inAnimation,
    Widget Function(Widget, Animation<double>)? outAnimation,
    bool onlyIfHasBuilder = false,
  }) {
    return SlotLayout(
      config: <Breakpoint, SlotLayoutConfig>{
        if (!onlyIfHasBuilder || smallBody != null)
          breakpoints.small: SlotLayout.from(
            key: Key('${prefix}small'),
            builder: this.smallBody,
            inAnimation: inAnimation,
            outAnimation: outAnimation,
          ),
        if (!onlyIfHasBuilder || body != null)
          breakpoints.medium: SlotLayout.from(
            key: Key('${prefix}medium'),
            builder: this.body,
            inAnimation: inAnimation,
            outAnimation: outAnimation,
          ),
        if (!onlyIfHasBuilder || mediumLargeBody != null)
          breakpoints.mediumLarge: SlotLayout.from(
            key: Key('${prefix}mediumLarge'),
            builder: this.mediumLargeBody,
            inAnimation: inAnimation,
            outAnimation: outAnimation,
          ),
        if (!onlyIfHasBuilder || largeBody != null)
          breakpoints.large: SlotLayout.from(
            key: Key('${prefix}large'),
            builder: this.largeBody,
            inAnimation: inAnimation,
            outAnimation: outAnimation,
          ),
        if (!onlyIfHasBuilder || extraLargeBody != null)
          breakpoints.extraLarge: SlotLayout.from(
            key: Key('${prefix}extraLarge'),
            builder: this.extraLargeBody,
            inAnimation: inAnimation,
            outAnimation: outAnimation,
          ),
      },
    );
  }
}
