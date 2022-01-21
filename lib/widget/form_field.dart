import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class RPMTWFormField extends StatelessWidget {
  final String fieldName;
  final TextEditingController? controller;
  final ValueChanged<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final String? hintText;
  final String? helperText;

  final bool hasDivider;
  final bool lockLine;
  final Widget? child;
  final bool seo;

  const RPMTWFormField(
      {Key? key,
      required this.fieldName,
      this.helperText,
      this.controller,
      this.onSaved,
      this.onChanged,
      this.textAlign,
      this.keyboardType,
      this.onEditingComplete,
      this.hasDivider = true,
      this.lockLine = true,
      this.validator,
      this.prefixIcon,
      this.hintText,
      this.child,
      this.seo = true})
      : super(key: key);

  double get splitWidth => kIsWebMobile ? 12 : 25;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: splitWidth),
            Expanded(
                child: TextFormField(
              controller: controller,
              validator: (value) {
                String? error = validator?.call(value);
                if (error != null) {
                  Utility.showErrorFlushbar(context, error);
                  return error;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: fieldName,
                prefixIcon: prefixIcon,
                hintText: hintText,
              ),
              maxLines: lockLine ? 1 : null,
              textAlign: textAlign ?? TextAlign.start,
              onSaved: (value) => onSaved?.call(value!),
              onChanged: (value) => onChanged?.call(value),
              keyboardType: keyboardType,
              onEditingComplete: onEditingComplete,
            )),
            SizedBox(width: splitWidth),
          ],
        ),
        _buildTooltip(context),
        child ?? const SizedBox.shrink(),
        (hasDivider && helperText != null)
            ? Column(
                children: [
                  SizedBox(height: kSplitHight),
                  const RPMTWDivider(),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTooltip(BuildContext context) {
    if (helperText != null) {
      return Column(
        children: [
          const SizedBox(height: 3),
          Row(
            children: [
              SizedBox(width: splitWidth),
              const Icon(Icons.lightbulb),
              SizedBox(width: splitWidth - 5),
              Expanded(
                  child: seo
                      ? SEOText(helperText!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 103, 170, 214)))
                      : Text(
                          helperText!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 103, 170, 214)),
                        )),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
