import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/components/custom_network_image.dart';

class CustomImageCard extends StatelessWidget {
  final String url;
  final double? width;
  final BorderRadius? borderRadius;

  const CustomImageCard({
    super.key,
    required this.url,
    this.width = 138.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      child: SizedBox(
        width: width,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(4.0),
          child: CustomNetworkImage(
            url: url,
            size: width!,
          ),
        ),
      ),
    );
  }
}
