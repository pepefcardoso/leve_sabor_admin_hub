import 'package:flutter/material.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double size;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.size,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, exception, stackTrace) {
        return SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'assets/images/blog_card_1.jpg',
            fit: fit,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: CircularProgressIndicator(
              color: CustomColors.verde3,
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          ),
        );
      },
    );
  }
}
