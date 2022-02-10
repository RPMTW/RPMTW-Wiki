import 'package:flutter/material.dart';

class MouseScale extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final double maxScale;

  const MouseScale(
      {Key? key,
      required this.child,
      this.initialScale = 1.0,
      this.maxScale = 1.15})
      : super(key: key);

  @override
  State<MouseScale> createState() => _MouseScaleState();
}

class _MouseScaleState extends State<MouseScale> {
  late double scale;

  @override
  void initState() {
    scale = widget.initialScale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(begin: 1.0, end: scale),
        builder: (BuildContext context, double value, _) {
          return Transform.scale(
            scale: value,
            child: MouseRegion(
                onEnter: (e) => _mouseEnter(true),
                onExit: (e) => _mouseEnter(false),
                child: widget.child),
          );
        });
  }

  void _mouseEnter(bool hover) {
    setState(() {
      if (hover) {
        scale = widget.maxScale;
      } else {
        scale = widget.initialScale;
      }
    });
  }
}
