import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedCheckbox extends ImplicitlyAnimatedWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? splashRadius;
  final Color? fillColor;
  final Color? overlayColor;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? borderColor;

  const AnimatedCheckbox({
    super.key,
    required super.duration,
    super.curve,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.side,
    this.shape,
    this.focusNode,
    this.autofocus = false,
    this.splashRadius,
    this.fillColor,
    this.overlayColor,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.borderColor,
  });

  @override
  AnimatedWidgetBaseState<AnimatedCheckbox> createState() => _AnimatedCheckboxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(ColorProperty('fillColor', fillColor, defaultValue: null));
    properties.add(ColorProperty('activeColor', overlayColor, defaultValue: null));
    properties.add(ColorProperty('activeColor', activeColor, defaultValue: null));
    properties.add(ColorProperty('checkColor', checkColor, defaultValue: null));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(ColorProperty('borderColor', borderColor, defaultValue: null));
  }
}

class _AnimatedCheckboxState extends AnimatedWidgetBaseState<AnimatedCheckbox> {
  ColorTween? _fillColor;
  ColorTween? _overlayColor;
  ColorTween? _activeColor;
  ColorTween? _checkColor;
  ColorTween? _focusColor;
  ColorTween? _hoverColor;
  ColorTween? _borderColor;

  static const VisualDensity _menorVisualDensityPossivel = VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity);
  static VisualDensity get _visualDensity => VisualDensity.lerp(VisualDensity.standard, _menorVisualDensityPossivel, 1);

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _fillColor = visitor(_fillColor, widget.fillColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _overlayColor = visitor(_overlayColor, widget.overlayColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _activeColor = visitor(_activeColor, widget.activeColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _checkColor = visitor(_checkColor, widget.checkColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _focusColor = visitor(_focusColor, widget.focusColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _hoverColor = visitor(_hoverColor, widget.hoverColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _borderColor = visitor(_borderColor, widget.borderColor, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;

    return Checkbox(
      value: widget.value,
      onChanged: widget.onChanged,
      tristate: widget.tristate,
      shape: widget.shape,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      splashRadius: widget.splashRadius,
      visualDensity: _visualDensity,
      fillColor: MaterialStateProperty.all(_fillColor?.evaluate(animation)),
      overlayColor: MaterialStateProperty.all(_overlayColor?.evaluate(animation)),
      side: widget.side?.copyWith(color: _borderColor?.evaluate(animation)),
      activeColor: _activeColor?.evaluate(animation),
      checkColor: _checkColor?.evaluate(animation),
      focusColor: _focusColor?.evaluate(animation),
      hoverColor: _hoverColor?.evaluate(animation),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);

    description.add(DiagnosticsProperty<ColorTween>('fillColor', _fillColor, defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('overlayColor', _overlayColor, defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('activeColor', _activeColor, defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('checkColor', _checkColor, defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('focusColor', _focusColor, defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('hoverColor', _hoverColor, defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('borderColor', _borderColor, defaultValue: null));
  }
}
