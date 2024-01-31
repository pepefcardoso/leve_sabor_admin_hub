import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class CustomListTag extends StatelessWidget {
  final String? label;
  final EdgeInsets? padding;
  final Color? color;

  const CustomListTag({
    super.key,
    this.label,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? CustomColors.verde2,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        label ?? '',
        style: Tipografia.corpo2Bold,
      ),
    );
  }
}
