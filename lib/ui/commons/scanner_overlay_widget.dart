import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  final double borderRadius;
  final double cutOutSize;

  const ScannerOverlay({
    super.key,
    this.borderRadius = 12.0,
    this.cutOutSize = 250.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;

      final cutOutTop = (height - cutOutSize) / 2;
      final cutOutLeft = (width - cutOutSize) / 2;

      return Stack(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Positioned(
                  top: cutOutTop,
                  left: cutOutLeft,
                  child: Container(
                    width: cutOutSize,
                    height: cutOutSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: cutOutTop,
            left: cutOutLeft,
            child: Container(
              width: cutOutSize,
              height: cutOutSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white70,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      );
    });
  }
}
