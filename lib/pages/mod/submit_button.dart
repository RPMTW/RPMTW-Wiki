import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';

class SubmitButton extends StatelessWidget {
  final void Function()? onPressed;
  const SubmitButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: localizations.addModSubmitTooltip,
          child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.send),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              label: Text(localizations.guiSubmit)),
        )
      ],
    );
  }
}
