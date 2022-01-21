import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';

class RowScrollView extends StatelessWidget {
  late final ScrollController _controller;
  final bool center;
  final Widget child;

  RowScrollView({
    Key? key,
    ScrollController? controller,
    this.center = true,
    required this.child,
  }) : super(key: key) {
    _controller = controller ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: center ? Alignment.center : Alignment.centerLeft,
        child: Scrollbar(
            thickness: Utility.isWebMobile ? 0.0 : null,
            controller: _controller,
            child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: child)));
  }
}
