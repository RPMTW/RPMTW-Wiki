import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:xml/xml.dart';

void main(List<String> arguments) async {
  RPMTWApiClient.init();
  RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
  int skip = 0;
  final Sitemap sitemap = Sitemap();
  String webDir = join(Directory.current.parent.parent.path, "web");

  while (true) {
    List<MinecraftMod> mods =
        await apiClient.minecraftResource.search(skip: skip);

    for (MinecraftMod mod in mods) {
      String description = mod.description ?? "";
      String imageUrl = mod.imageUrl(RPMTWApiClient.lastInstance.baseUrl) ??
          "https://raw.githubusercontent.com/RPMTW/RPMTW-Data/main/logo/rpmtw-logo.png";
      String url = "https://wiki.rpmtw.com/#/mod/view/${mod.uuid}";
      String title = "${mod.name} | RPMTW Wiki";

      String html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="$description">
  <meta property="og:image" content="$imageUrl" />
  <meta property="og:description" content="$description">
  <meta property="og:title" content="$title">

  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="RPMTW Wiki">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <meta name="keywords" content="RPMTW,minecraft,mod,RPMTW Wiki,Minecraft Wiki,RPMWiki,當個創世神百科,我的世界百科">
  <link rel="icon" type="image/png" href="favicon.png" />

  <title>$title</title>
</head>

<meta http-equiv="refresh" content="0; url=$url" />

<script language="javascript">
  window.location = "$url";
</script>
</html>
    """;

      File file = File(join(webDir, "mod", "view", "${mod.uuid}.html"));
      await file.create(recursive: true);
      await file.writeAsString(html);
      sitemap.entries.add(SitemapEntry()..location = url);
    }

    if (mods.length < 50) {
      File file = File(join(webDir, "sitemap.xml"));
      await file.create(recursive: true);
      await file.writeAsString(sitemap.generate());
      exit(0);
    }

    skip += 50;
  }
}

class Sitemap {
  String? stylesheetPath;

  List<SitemapEntry> entries = [];

  String generate() {
    final dateFormatter = DateFormat('yyyy-MM-dd');

    final root = XmlElement(XmlName('urlset'), [
      XmlAttribute(
          XmlName('xmlns'), 'http://www.sitemaps.org/schemas/sitemap/0.9'),
      XmlAttribute(XmlName('xmlns:xhtml'), 'http://www.w3.org/1999/xhtml')
    ]);

    for (final entry in entries) {
      final url = XmlElement(XmlName('url'));

      final location = XmlElement(XmlName('loc'));
      location.children.add(XmlText(entry.location));
      url.children.add(location);

      url.children.addAll(entry.alternates
          .map<String, XmlNode>(
              (String language, String location) => MapEntry<String, XmlNode>(
                  language,
                  XmlElement(XmlName('xhtml:link'), [
                    XmlAttribute(XmlName('rel'), 'alternate'),
                    XmlAttribute(XmlName('hreflang'), language),
                    XmlAttribute(XmlName('href'), location)
                  ])))
          .values);

      final lastMod = XmlElement(XmlName('lastmod'));
      lastMod.children.add(XmlText(dateFormatter.format(entry.lastModified)));
      url.children.add(lastMod);

      final changeFrequency = XmlElement(XmlName('changefreq'));
      changeFrequency.children.add(XmlText(entry.changeFrequency));
      url.children.add(changeFrequency);

      final priority = XmlElement(XmlName('priority'));
      priority.children.add(XmlText(entry.priority.toString()));
      url.children.add(priority);

      root.children.add(url);
    }

    String stylesheet = '';
    if (stylesheetPath != null) {
      stylesheet = '<?xml-stylesheet type="text/xsl" href="$stylesheetPath"?>';
    }

    return '<?xml version="1.0" encoding="UTF-8"?>$stylesheet$root';
  }
}

class SitemapEntry {
  String location = '';
  DateTime lastModified = DateTime.now();
  String changeFrequency = 'yearly';
  num priority = 0.5;
  final Map<String, String> _alternates = {};
  Map<String, String> get alternates => _alternates;
  void addAlternate(String language, String location) =>
      _alternates[language] = location;
}
