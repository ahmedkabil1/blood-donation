import 'package:flutter/material.dart';

/// Decorative drop used in the hero and auth panels
/// (stand-in for the hands-holding-a-drop photo from Figma).
class BloodDropGraphic extends StatelessWidget {
  const BloodDropGraphic({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Color(0x55FFFFFF), Color(0x00FFFFFF)]),
            ),
          ),
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE53935), Color(0xFF7F0000)],
            ).createShader(rect),
            child: Icon(Icons.water_drop, size: size * 0.7, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
