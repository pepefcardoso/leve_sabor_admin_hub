import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/components/checkbox/checkbox.dart';
import 'package:leve_sabor_admin_hub/components/checkbox/checkbox_group_controller.dart';

typedef OnChangedGroupCheckbox<T> = void Function(T changedItem);

class CheckboxGroup<T> extends StatefulWidget {
  final Map<String, T> options;
  final List<T>? groupItems;
  final OnChangedGroupCheckbox<T>? onChangedItem;
  final CheckboxGroupController<T>? controller;
  final Axis axis;
  final CheckboxSize size;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double spacing;
  final bool enabled;

  const CheckboxGroup({
    super.key,
    required this.options,
    this.groupItems,
    this.onChangedItem,
    this.axis = Axis.horizontal,
    this.controller,
    this.size = CheckboxSize.medium,
    this.mainAxisSpacing = 14.0,
    this.crossAxisSpacing = 6.0,
    this.spacing = 6.0,
    this.enabled = true,
  });

  @override
  State<StatefulWidget> createState() => _CheckboxGroupState<T>();
}

class _CheckboxGroupState<T> extends State<CheckboxGroup<T>> {
  late final CheckboxGroupController<T> _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? CheckboxGroupController<T>(groupItems: widget.groupItems ?? []);
    _controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant CheckboxGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.groupItems != widget.groupItems) {
      if (widget.groupItems != null) {
        _controller.removeAndAddAll(widget.groupItems!);
      } else {
        _controller.clear();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _listener() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.axis,
      spacing: widget.mainAxisSpacing,
      runSpacing: widget.crossAxisSpacing,
      children: widget.options.entries.map((option) {
        final bool isSelected = (option.value is bool) ? (option.value as bool) : (_controller.groupItems.contains(option.value));

        return BaseCheckbox(
          label: option.key,
          tristate: false,
          initialValue: (isSelected),
          size: widget.size,
          spacing: widget.spacing,
          onChangedValue: widget.enabled
              ? (bool? value) {
                  if (value == true) {
                    _controller.add(option.value);
                  } else {
                    _controller.remove(option.value);
                  }

                  if (widget.onChangedItem != null) {
                    widget.onChangedItem!.call(option.value);
                  }
                }
              : null,
        );
      }).toList(),
    );
  }
}

enum CheckboxSize {
  small(0.65),
  medium(1.0),
  big(1.2);

  final double scale;

  const CheckboxSize(this.scale);
}
