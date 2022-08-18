import 'dart:ui';

import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({super.key, this.value = 0});

  final double value;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: value,
        sigmaY: value,
      ),
      child: const ColoredBox(
        color: Colors.transparent,
      ),
    );
  }
}
