import 'package:flutter/material.dart';

Duration motionDuration(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : const Duration(milliseconds: 400);

PageRouteBuilder<T> fadeRoute<T>(BuildContext context, Widget page) =>
    PageRouteBuilder<T>(
      transitionDuration: motionDuration(context),
      reverseTransitionDuration: motionDuration(context),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
            child: child,
          ),
    );
