import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class HomePageButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;

  const HomePageButton({
    super.key,
    required this.label,
    required this.icon,
    required this.route,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => GoRouter.of(context).go(route),
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.green[800],
              size: 64.0,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: Tipografia.titulo3,
            ),
          ],
        ),
      ),
    );
  }
}
