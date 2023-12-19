import 'package:flutter/widgets.dart';

import '../../fields/fields.dart';
import 'base/addon.dart';
import 'base/mode.dart';
import 'base/mode_addon.dart';

class ZoomMode extends Mode<double> {
  ZoomMode(super.value);

  @override
  Widget build(BuildContext context, Widget child) {
    return Transform.scale(
      scale: value,
      child: child,
    );
  }
}

/// An [Addon] for zoom/scaling.
class ZoomAddon extends ModeAddon<double> {
  ZoomAddon()
      : super(
          name: 'Zoom',
          modeBuilder: ZoomMode.new,
        );

  @override
  List<Field> get fields {
    return [
      DoubleSliderField(
        name: 'ratio',
        initialValue: 1,
        min: 0.25,
        max: 4,
        divisions: 4 * 4 - 1,
      ),
    ];
  }

  @override
  double valueFromQueryGroup(Map<String, String> group) {
    return valueOf('ratio', group)!;
  }
}
