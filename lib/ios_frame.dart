import 'package:flutter/material.dart';
import 'theme.dart';

/// On wide screens (web/desktop) center the app inside a phone-sized frame.
class IOSFrameHost extends StatelessWidget {
  final Widget child;
  const IOSFrameHost({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final needsFrame = size.width > 520;
    if (!needsFrame) return child;
    return Container(
      color: const Color(0xFFE6DAC5),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: AspectRatio(
          aspectRatio: 402 / 874,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(46),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 60,
                    offset: const Offset(0, 30)),
              ],
              border: Border.all(color: const Color(0xFF171515), width: 10),
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(36), child: child),
          ),
        ),
      ),
    );
  }
}

/// Per-screen chrome: status bar time + home indicator over the screen body.
class IOSFrame extends StatelessWidget {
  final Widget child;
  final bool dark;
  const IOSFrame({super.key, required this.child, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.ink;
    return Material(
      color: dark ? const Color(0xFF171515) : AppColors.bg,
      child: Stack(
        children: [
          Positioned.fill(child: MediaQuery.removePadding(context: context, removeTop: true, child: child)),
          // status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 14, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('9:41',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: fg)),
                    Row(children: [
                      Icon(Icons.signal_cellular_alt, size: 15, color: fg),
                      const SizedBox(width: 5),
                      Icon(Icons.wifi, size: 15, color: fg),
                      const SizedBox(width: 5),
                      Icon(Icons.battery_full, size: 16, color: fg),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          // home indicator
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: fg.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
