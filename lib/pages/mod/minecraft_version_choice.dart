import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/rpmtw_theme.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class MinecraftVersionChoice extends StatefulWidget {
  final List<MinecraftVersion> allVersions;
  final void Function(List<String>) onChanged;
  final List<String>? defaultValue;
  
  const MinecraftVersionChoice(
      {Key? key,
      required this.allVersions,
      required this.onChanged,
      this.defaultValue})
      : super(key: key);

  @override
  State<MinecraftVersionChoice> createState() => _MinecraftVersionChoiceState();
}

class _MinecraftVersionChoiceState extends State<MinecraftVersionChoice> {
  late List<String> versions;

  @override
  void initState() {
    versions = widget.defaultValue ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: kSplitWidth),
        SEOText(localizations.addModSupportedVersionField,
            style: RPMTWTheme.titleTextStyle),
        FormField<List<String>>(
          initialValue: versions,
          validator: (value) {
            if (value!.isEmpty) {
              String error = localizations.addModSupportedVersionNull;
              Utility.showErrorFlushbar(context, error);

              return error;
            }
            return null;
          },
          builder: (field) {
            return UnmanagedRestorationScope(
                bucket: field.bucket,
                child: SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: versions.isNotEmpty
                          ? versions.reduce(
                              (a, b) => a + localizations.guiSeparator + b)
                          : localizations.addModSupportedVersionHint,
                    ),
                    isDense: true,
                    onChanged: (x) {},
                    selectedItemBuilder: (context) {
                      return widget.allVersions
                          .map((e) => DropdownMenuItem(
                                child: Container(),
                              ))
                          .toList();
                    },
                    items: widget.allVersions.map((e) {
                      String versionID = e.id;

                      return DropdownMenuItem<String>(
                        enabled: false,
                        child: Row(
                          children: [
                            StatefulBuilder(
                                builder: (context, _setCheckBoxState) {
                              return Checkbox(
                                  value: versions.contains(versionID),
                                  onChanged: (isSelected) {
                                    if (isSelected!) {
                                      var ns = versions;
                                      ns.add(versionID);
                                      widget.onChanged(ns);
                                    } else {
                                      var ns = versions;
                                      ns.remove(versionID);
                                      widget.onChanged(ns);
                                    }
                                    _setCheckBoxState(() {});
                                    setState(() {});
                                  });
                            }),
                            SEOText(versionID)
                          ],
                        ),
                        value: versionID,
                      );
                    }).toList(),
                  ),
                ));
          },
        ),
      ],
    );
  }
}
