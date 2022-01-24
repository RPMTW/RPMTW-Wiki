import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class RPMTWFormField extends StatefulWidget {
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
  final String? defaultValue;

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
      this.defaultValue,
      this.seo = true})
      : super(key: key);

  @override
  State<RPMTWFormField> createState() => _RPMTWFormFieldState();
}

class _RPMTWFormFieldState extends State<RPMTWFormField> {
  double get splitWidth => kIsMobile ? 12 : 25;

  late TextEditingController controller;

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    } else {
      controller = TextEditingController();
    }

    if (widget.defaultValue != null) {
      controller.text = widget.defaultValue!;
    }

    super.initState();
  }

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
                String? error = widget.validator?.call(value);
                if (error != null) {
                  Utility.showErrorFlushbar(context, error);
                  return error;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: widget.fieldName,
                prefixIcon: widget.prefixIcon,
                hintText: widget.hintText,
              ),
              maxLines: widget.lockLine ? 1 : null,
              textAlign: widget.textAlign ?? TextAlign.start,
              onSaved: (value) => widget.onSaved?.call(value!),
              onChanged: (value) => widget.onChanged?.call(value),
              keyboardType: widget.keyboardType,
              onEditingComplete: widget.onEditingComplete,
            )),
            SizedBox(width: splitWidth),
          ],
        ),
        _buildTooltip(context),
        widget.child ?? const SizedBox.shrink(),
        (widget.hasDivider && widget.helperText != null)
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
    if (widget.helperText != null) {
      return Column(
        children: [
          const SizedBox(height: 3),
          Row(
            children: [
              SizedBox(width: splitWidth),
              const Icon(Icons.lightbulb),
              SizedBox(width: splitWidth - 5),
              Expanded(
                  child: widget.seo
                      ? SEOText(widget.helperText!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 103, 170, 214)))
                      : Text(
                          widget.helperText!,
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
