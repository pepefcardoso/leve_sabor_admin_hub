import 'package:flutter/material.dart';

class RadioController<T> extends ValueNotifier<T?> {
  RadioController({T? value}) : super(value);
}

class RadioGroup<T> extends StatefulWidget {
  final RadioController<T> controller;
  final VoidCallback? onChanged;
  final List<String> items;

  const RadioGroup({
    super.key,
    required this.controller,
    required this.items,
    this.onChanged,
  }) : super();

  @override
  State<RadioGroup<T>> createState() => _RadioGroupState<T>();
}

class _RadioGroupState<T> extends State<RadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in widget.items)
          RadioListTile<T>(
            title: Text(item),
            value: item as T,
            groupValue: widget.controller.value,
            onChanged: (T? value) {
              setState(() => widget.controller.value = value);
              widget.onChanged?.call();
            },
          ),
      ],
    );
  }
}
