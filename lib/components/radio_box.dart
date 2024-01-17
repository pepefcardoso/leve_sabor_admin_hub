import 'package:flutter/material.dart';

class RadioController<String> extends ValueNotifier<String?> {
  RadioController({String? value}) : super(value);
}

class RadioGroup<String> extends StatefulWidget {
  final RadioController<String> controller;
  final VoidCallback? onChanged;
  final List<String> items;

  const RadioGroup({
    super.key,
    required this.controller,
    required this.items,
    this.onChanged,
  }) : super();

  @override
  State<RadioGroup<String>> createState() => _RadioGroupState<String>();
}

class _RadioGroupState<String> extends State<RadioGroup<String>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in widget.items)
          RadioListTile(
            title: Text(item.toString()),
            value: item,
            groupValue: widget.controller.value,
            onChanged: (String? value) {
              setState(() => widget.controller.value = value);
              widget.onChanged?.call();
            },
          ),
      ],
    );
  }
}
