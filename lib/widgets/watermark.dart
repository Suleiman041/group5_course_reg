import 'package:flutter/material.dart';

import '../theme.dart';

/// Puts a faded BUK logo behind any screen.
/// The logo path is set in theme.dart (logoPath). If the file is
/// missing, a school icon is shown instead so the app never crashes.
class Watermark extends StatelessWidget {
  final Widget child;
  const Watermark({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Center(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                logoPath,
                width: 260,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.school, size: 260, color: accent),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
