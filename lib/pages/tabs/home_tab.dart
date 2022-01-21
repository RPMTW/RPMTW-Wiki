import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _ModTabState createState() => _ModTabState();
}

class _ModTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Column(
      children: const [Text("test home page")],
    ));
  }
}
