import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/components/radio_box/radio_box.dart';
import 'package:leve_sabor_admin_hub/components/radio_box/radio_box_controller.dart';

class RadioBoxGroup<T> extends StatefulWidget {
  final Map<String, T> options;
  final T? groupValue;
  final Axis axis;
  final bool toggleable;
  final RadioBoxController<T>? controller;
  final ValueChanged<T?>? onChanged;
  final RadioBoxSize size;
  final double spacing;
  final double optionsSpacing;
  final bool enabled;

  const RadioBoxGroup({
    super.key,
    required this.options,
    this.groupValue,
    this.axis = Axis.horizontal,
    this.toggleable = false,
    this.controller,
    this.onChanged,
    this.size = RadioBoxSize.medium,
    this.spacing = 4.0,
    this.optionsSpacing = 4.0,
    this.enabled = true,
  });

  @override
  State<StatefulWidget> createState() => _RadioBoxGroupState<T>();
}

class _RadioBoxGroupState<T> extends State<RadioBoxGroup<T>> {
  late final RadioBoxController<T> _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? RadioBoxController<T>(widget.groupValue);
    _controller.addListener(() {
      if (!mounted) {
        return;
      }
      return setState(() {});
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
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.axis,
      spacing: widget.optionsSpacing,
      children: _obterOpcoes,
    );
  }

  List<Widget> get _obterOpcoes {
    return widget.options.entries.map((opcao) {
      return RadioBox(
        enabled: widget.enabled,
        label: opcao.key,
        value: opcao.value,
        groupValue: _controller.item,
        toggleable: widget.toggleable,
        size: widget.size,
        spacing: widget.spacing,
        onChanged: (T? valor) {
          _controller.item = valor;
          widget.onChanged?.call(valor);
        },
      );
    }).toList();
  }
}

enum RadioBoxSize {
  small(0.8),
  medium(1.0),
  big(1.2);

  final double scale;

  const RadioBoxSize(this.scale);
}
