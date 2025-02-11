import 'package:flutter/material.dart';

class AnimationHelper {
  static Widget slideInFromBottom(Widget child, {double delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOut,
      tween: Tween(begin: 50, end: 0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOut,
            tween: Tween(begin: 0, end: 1),
            builder: (context, opacity, child) {
              return Opacity(opacity: opacity, child: child);
            },
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget fadeIn(Widget child, {double delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: child,
    );
  }

  static Widget scaleIn(Widget child) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      tween: Tween(begin: 0.95, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
} 