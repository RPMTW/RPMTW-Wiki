import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:universal_html/html.dart';

import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/row_scroll_view.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class BasePage extends StatelessWidget {
  final WidgetBuilder builder;
  final bool loading;
  const BasePage({Key? key, required this.builder, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        controller: ScrollController(),
        children: [
          if (loading)
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                ],
              ),
            )
          else
            builder.call(context),
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
    return Container(
      padding: kIsDesktop
          ? const EdgeInsets.only(left: 30, top: 30, right: 30)
          : null,
      child: Column(
        children: [
          const RPMTWDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/RPMWiki_Logo.svg",
                  width: 40, height: 40),
              SizedBox(width: kSplitWidth),
              const Text("RPMWiki", style: TextStyle(fontSize: 25)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SEOSelectableText(localizations.footerDescription,
                style: const TextStyle(color: Colors.white70)),
          ),
          kIsDesktop
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ..._buildRow1(),
                    Container(
                      color: Colors.white24,
                      width: 2,
                      height: 100,
                    ),
                    _buildRow2(),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _buildRow1()),
                    ),
                    const RPMTWDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildRow2(),
                    )
                  ],
                ),
          const RPMTWDivider(),
        ],
      ),
    );
  }

  List<Widget> _buildRow1() {
    return [
      _FooterColumn(
        heading: localizations.footerAbout,
        s1: LinkText(
            link: "mailto:rpmtw666@gmail.com",
            text: localizations.footerAboutConnect),
        s2: LinkText(
            link: "https://www.rpmtw.com/About",
            text: localizations.footerAboutUs),
      ),
      _FooterColumn(
        heading: localizations.footerHelp,
        s1: LinkText(
            link: "https://www.rpmtw.com/Wiki",
            text: localizations.footerHelpFAQ),
        s2: LinkText(
            link: "https://ko-fi.com/siongsng",
            text: localizations.footerHelpSponsor),
      ),
      _FooterColumn(
        heading: localizations.footerResources,
        s1: LinkText(
            link: "https://discord.gg/5xApZtgV2u",
            text: localizations.footerResourcesDiscord),
        s2: LinkText(
            link: "https://www.rpmtw.com", text: localizations.guiWebsite),
      ),
    ];
  }

  Column _buildRow2() {
    return Column(
      crossAxisAlignment:
          kIsMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const _CreativeCommons(),
        Text(localizations.guiCopyright),
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
                    child: SEOText(lookupAppLocalizations(locale).languageName,
                        style:
                            const TextStyle(fontSize: 17.5, fontFamily: 'font'),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis),
                  );
                }).toList()))
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

class _FooterColumn extends StatelessWidget {
  final String heading;
  final LinkText s1;
  final LinkText s2;

  const _FooterColumn({
    Key? key,
    required this.heading,
    required this.s1,
    required this.s2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SEOText(
            heading,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          s1,
          SizedBox(height: kSplitHight),
          s2,
        ],
      ),
    );
  }
}
