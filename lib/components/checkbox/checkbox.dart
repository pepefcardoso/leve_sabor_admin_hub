import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/components/checkbox/animated_checkbox.dart';
import 'package:leve_sabor_admin_hub/components/checkbox/checkbox_group.dart';
import 'package:leve_sabor_admin_hub/components/interactive_text.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

const Duration _kAnimationDuration = Duration(milliseconds: 150);
const Curve _kAnimationCurve = Curves.linear;

class BaseCheckbox extends StatefulWidget {
  final bool? initialValue;
  final BaseCheckboxController? controller;
  final String? label;
  final CheckboxSize size;
  final double spacing;
  final ValueChanged<bool?>? onChangedValue;
  final bool tristate;
  final bool enabled;

  const BaseCheckbox({
    super.key,
    this.initialValue,
    this.controller,
    this.label,
    this.size = CheckboxSize.medium,
    this.spacing = 16.0,
    required this.onChangedValue,
    this.tristate = false,
    this.enabled = true,
  });

  @override
  State<BaseCheckbox> createState() => _BaseCheckboxState();
}

class _BaseCheckboxState extends State<BaseCheckbox> {
  late final BaseCheckboxController _controller;

  bool get _tristate => (widget.tristate);

  bool get _enabledCheckbox => (widget.onChangedValue != null && widget.enabled);

  bool? get _value => (_controller.valor);

  @override
  void initState() {
    super.initState();

    // Como a checkbox pode ser tristate, e com isso o valor inicial pode ser null,
    // então a regra de negócio para o controller interno será apenas se ele passar um controller externo.
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = BaseCheckboxController(valor: (_tristate) ? widget.initialValue : (widget.initialValue ?? false));
    }

    assert((_tristate || _value != null), 'O valor da checkbox não pode ser nulo quando ela não é [tristate].');

    _controller.addListener(() {
      if (!mounted) return;

      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BaseCheckbox oldWidget) {
    if (_controller.valor != widget.initialValue) {
      setState(() {
        _controller.valor = widget.initialValue;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Transform.scale(
            scale: widget.size.scale,
            child: AnimatedCheckbox(
              key: widget.key,
              duration: _kAnimationDuration,
              curve: _kAnimationCurve,
              value: !widget.tristate ? _value! : _value,
              onChanged: (_enabledCheckbox) ? (value) => _onPressedAction(value) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              splashRadius: 0,
              checkColor: (_enabledCheckbox) ? CustomColors.verde3 : Colors.grey,
              fillColor: Colors.white,
              borderColor: CustomColors.verde3,
              tristate: widget.tristate,
              side: const BorderSide(width: 1.6),
            ),
          ),
        ),
        if (widget.label != null)
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: widget.spacing),
              child: InteractiveText(
                text: Text(
                  widget.label!,
                  style: Tipografia.corpo2,
                ),
                onPressed: () => _onPressedLabel(),
              ),
            ),
          ),
      ],
    );
  }

  void _onPressedLabel() {
    if (!_enabledCheckbox) return;

    if (widget.tristate) {
      if (_value == null) {
        _onPressedAction(true);
      } else if (_value == true) {
        _onPressedAction(false);
      } else {
        _onPressedAction(null);
      }

      return;
    }

    _onPressedAction(!_value!);
  }

  void _onPressedAction(bool? newValue) {
    _controller.valor = newValue;
    widget.onChangedValue?.call(newValue);
  }
}

class BaseCheckboxController extends ValueNotifier<bool?> {
  BaseCheckboxController({bool? valor}) : super(valor);

  bool? get valor => value;

  set valor(bool? newValue) => value = newValue;
}
