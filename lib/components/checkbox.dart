import 'package:flutter/material.dart';

class CheckboxGroupController extends ValueNotifier<List<String>> {
  CheckboxGroupController(super.value);

  void addItem(String item) {
    value = [...value, item];
  }

  void removeItem(String item) {
    value = value.where((e) => e != item).toList();
  }

  bool containsItem(String item) {
    return value.contains(item);
  }
}

class CheckboxGroup extends StatefulWidget {
  final List<String> items;
  final CheckboxGroupController controller;

  const CheckboxGroup({
    super.key,
    required this.items,
    required this.controller,
  });

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: widget.controller.containsItem(item),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      widget.controller.addItem(item);
                    } else {
                      widget.controller.removeItem(item);
                    }
                  }
                });
              },
            ),
            Text(item),
          ],
        );
      }).toList(),
    );
  }
}
