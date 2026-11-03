import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MobilePreview extends StatelessWidget {
  static const _screen = Size(390, 844);
  static const _bezel = 12.0;
  static const _radius = 46.0;
  static const _statusBar = 47.0;
  static const _homeBar = 21.0;

  final Widget child;
  const MobilePreview({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (!kIsWeb || media.size.shortestSide < 600) return child;

    const insets = EdgeInsets.only(top: _statusBar, bottom: _homeBar);
    return ColoredBox(
      color: PortalColors.previewBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        // Shrinks the phone to fit short windows; never enlarges it.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: PortalColors.frame,
              borderRadius: BorderRadius.circular(_radius + _bezel),
              boxShadow: const [
                BoxShadow(
                  color: PortalColors.previewShadow,
                  blurRadius: 48,
                  offset: Offset(0, 24),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(_bezel),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_radius),
                child: SizedBox.fromSize(
                  size: _screen,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // The app sees a phone-sized screen with a status bar
                      // and home indicator, so SafeArea and AppBar pad for them.
                      MediaQuery(
                        data: media.copyWith(
                          size: _screen,
                          padding: insets,
                          viewPadding: insets,
                        ),
                        child: child,
                      ),
                      const IgnorePointer(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 11,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: _Pill(
                                  width: 120,
                                  height: 34,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: _Pill(
                                  width: 134,
                                  height: 5,
                                  color: Color(0x99000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final double width, height;
  final Color color;
  const _Pill({required this.width, required this.height, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    ),
  );
}
