import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/components/interactive_text.dart';
import 'package:leve_sabor_admin_hub/components/radio_box/radio_box_group.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class RadioBox<T> extends StatefulWidget {
  final bool enabled;
  final String label;
  final T value;
  final T? groupValue;
  final RadioBoxSize size;
  final double spacing;
  final bool toggleable;
  final ValueChanged<T?>? onChanged;

  const RadioBox({
    super.key,
    required this.label,
    required this.value,
    this.size = RadioBoxSize.medium,
    this.spacing = 8.0,
    this.groupValue,
    this.toggleable = false,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<RadioBox<T>> createState() => _RadioBoxState<T>();
}

class _RadioBoxState<T> extends State<RadioBox<T>> {
  bool get _enabled => (widget.enabled);

  T get _value => (widget.value);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.size.scale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            value: _value,
            fillColor: MaterialStateColor.resolveWith((states) => CustomColors.verde1),
            splashRadius: 0,
            groupValue: widget.groupValue,
            onChanged: _enabled ? (T? newValue) => _onPressedAction(newValue) : null,
            toggleable: widget.toggleable,
          ),
          Flexible(
            flex: 10,
            child: Padding(
              padding: EdgeInsets.only(left: widget.spacing),
              child: InteractiveText(
                text: Text(
                  widget.label,
                  style: Tipografia.corpo2,
                ),
                onPressed: () => _onPressedLabel(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressedLabel() {
    if (!_enabled) return;
    _onPressedAction(_value);
  }

  void _onPressedAction(T? newValue) {
    widget.onChanged?.call(newValue);
  }
}
