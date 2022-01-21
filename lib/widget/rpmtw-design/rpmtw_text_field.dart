import 'package:flutter/material.dart';

class RPMTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String value)? verify;
  final String? hintText;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;
  final bool lockLine;

  const RPMTextField(
      {Key? key,
      this.controller,
      this.onChanged,
      this.verify,
      this.hintText,
      this.textAlign = TextAlign.center,
      this.keyboardType,
      this.onEditingComplete,
      this.lockLine = true})
      : super(key: key);

  @override
  State<RPMTextField> createState() => _RPMTextFieldState();
}

class _RPMTextFieldState extends State<RPMTextField> {
  Color enabledColor = Colors.white12;
  Color focusedColor = Colors.lightBlue;
  String? errorText;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => enabledColor = Theme.of(context).backgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: enabledColor, width: 3.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedColor, width: 3.0),
            ),
            errorText: errorText),
        maxLines: widget.lockLine ? 1 : null,
        textAlign: widget.textAlign,
        keyboardType: widget.keyboardType,
        onEditingComplete: widget.onEditingComplete,
        onChanged: (value) {
          String? verifyResult = widget.verify?.call(value);

          if (verifyResult != null) {
            enabledColor = Colors.red;
            focusedColor = Colors.red;
            errorText = verifyResult;
          } else {
            enabledColor = Theme.of(context).backgroundColor;
            focusedColor = Colors.lightBlue;
            widget.onChanged?.call(value);
            errorText = null;
          }
          setState(() {});
        });
  }
}
