import 'package:flutter/material.dart';

class InteractiveText extends StatelessWidget {
  final Text text;
  final VoidCallback? onPressed;

  const InteractiveText({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      child: GestureDetector(
        onTap: onPressed,
        child: text,
      ),
    );
  }
}
