import 'package:flutter/material.dart';

class RPMTWDivider extends StatelessWidget {
  const RPMTWDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 2.0,
      height: 1,
    );
  }
}

class RPMTWVerticalDivider extends StatelessWidget {
  const RPMTWVerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      thickness: 2.0,
    );
  }
}
