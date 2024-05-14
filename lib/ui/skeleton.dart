import 'package:flutter/material.dart';

class SkeletonPlaceholder extends StatelessWidget {
  final double? height, width;
  const SkeletonPlaceholder({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Color.fromARGB(209, 158, 158, 158),
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
    );
  }
}
