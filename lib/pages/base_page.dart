import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/row_scroll_view.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:universal_html/html.dart';

import 'package:rpmtw_wiki/widget/seo_text.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final bool loading;
  const BasePage({Key? key, required this.child, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        controller: ScrollController(),
        children: [
          Builder(builder: (context) {
            if (loading) {
              return Center(
                child: Column(
                  children: const [
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                    SizedBox(height: 15),
                  ],
                ),
              );
            } else {
              return child;
            }
          }),
          const _Footer(),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}

class _Footer extends StatefulWidget {
  const _Footer({
    Key? key,
  }) : super(key: key);

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RPMTWDivider(),
        const SizedBox(height: 2),
        LinkText(link: "https://www.rpmtw.com", text: localizations.guiWebsite),
        const _CreativeCommons(),
        SEOText(localizations.guiCopyright, textAlign: TextAlign.center),
        SizedBox(
          width: 150,
          child: DropdownButton<Locale>(
            value: locale,
            style: const TextStyle(color: Colors.lightBlue),
            onChanged: (_locale) {
              setState(() {
                locale = _locale!;
              });

              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  window.location.reload();
                });
              });
            },
            isExpanded: true,
            items: AppLocalizations.supportedLocales
                .where((locale) => !(locale.languageCode == "zh" &&
                    locale.scriptCode == null &&
                    locale.countryCode == null))
                .map<DropdownMenuItem<Locale>>((Locale locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                alignment: Alignment.center,
                child: Text(lookupAppLocalizations(locale).languageName,
                    style: const TextStyle(fontSize: 17.5, fontFamily: 'font'),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CreativeCommons extends StatelessWidget {
  const _CreativeCommons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String localeName = WidgetsBinding.instance!.window.locale.toString();

    return RowScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SEOText(localizations.footerCC1),
              const SizedBox(width: 5),
              LinkText(
                  link:
                      "https://creativecommons.org/licenses/by-nc-sa/4.0/deed.$localeName",
                  text: localizations.footerCC2),
            ],
          ),
          const SizedBox(width: 5),
          Image.asset("assets/images/cc-by-nc-sa.png"),
        ],
      ),
    );
  }
}
