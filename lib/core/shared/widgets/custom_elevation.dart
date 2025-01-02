import 'package:flutter/material.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double opacity;

  const CustomElevation({
    super.key,
    required this.child,
    required this.color,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withOpacity(opacity),
            blurRadius: radius,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
