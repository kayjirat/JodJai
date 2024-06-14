import 'package:flutter/material.dart';

class ECircularContainer extends StatelessWidget {
  const ECircularContainer(
      {super.key, this.child, this.width = 400, this.height = 400});
  final double? width;
  final double? height;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(400),
          color: Colors.white.withOpacity(0.4)),
      child: child,
    );
  }
}
