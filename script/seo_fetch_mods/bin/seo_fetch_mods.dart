import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:xml/xml.dart';

void main(List<String> arguments) async {
  RPMTWApiClient.init();
  RPMTWApiClient apiClient = RPMTWApiClient.instance;
  int skip = 0;
  final Sitemap sitemap = Sitemap();
  String webDir = join(Directory.current.parent.parent.path, "web");

  while (true) {
    List<MinecraftMod> mods =
        await apiClient.minecraftResource.search(skip: skip);

    for (MinecraftMod mod in mods) {
      String description =
          "${mod.description ?? ""} | 從今天起開始使用 RPMWiki 吧！，RPMWiki 是個全新的 Minecraft 百科平台，Minecraft 中包羅萬象的知識內容全都在這裡，包含模組、模組包、地圖等內容";

      String imageUrl = mod.imageUrl ??
          "https://raw.githubusercontent.com/RPMTW/RPMTW-Data/main/logo/rpmtw-logo.png";
      String name = mod.name;
      if (mod.translatedName != null && mod.translatedName!.isNotEmpty) {
        name += " (${mod.translatedName!})";
      }
      String url = "https://wiki.rpmtw.com/mod/view/${mod.uuid}";
      String title = "$name | RPMWiki - 全台最大 Minecraft 模組百科";
      String siteName = "RPMTW Wiki";

      String html = """
<!DOCTYPE html>
<html>
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="$description">
  <meta property="og:image" content="$imageUrl" />
  <meta property="og:image:width" content="256" />
  <meta property="og:image:height" content="256" />
  <meta property="og:description" content="$description">
  <meta property="og:title" content="$title">
  <meta property="og:site_name" content="$siteName">
  <meta property="og:type" content="article">
  <meta property="article:published_time" content="${mod.createTime.toIso8601String()}" />
  <meta property="article:modified_time" content="${mod.lastUpdate.toIso8601String()}" />

  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="$title">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <meta name="keywords" content="RPMTW,minecraft,mod,RPMTW Wiki,Minecraft Wiki,RPMWiki,當個創世神百科,我的世界百科">
  <link rel="icon" type="image/png" href="favicon.png" />

  <title>$title</title>
  <link rel="manifest" href="manifest.json">
  <link rel="preload" href="main.dart.js" as="script">
  <link rel="preload" href="https://unpkg.com/canvaskit-wasm@0.32.0/bin/canvaskit.js" as="script">
  <link rel="preload" href="https://unpkg.com/canvaskit-wasm@0.32.0/bin/canvaskit.wasm" as="fetch"
    crossorigin="anonymous">

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    .container {
      width: 100vw;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;
    }

    .logo img {
      width: 250px;
      height: 250px;
      object-fit: cover;
    }

    .logo p {
      color: #ffffff;
      font: sans-serif;
      font-size: 25px;
      font-display: bold;
      margin-left: 75px;
      margin-top: -20px;
      margin-bottom: 5px;
    }

    .loading div {
      height: 25px;
      width: 25px;
      border-radius: 50%;
      transform: scale(0);
      background-color: red;
      animation: scaling 2s ease-in-out infinite;
      display: inline-block;
    }

    .loading div:nth-child(0) {
      animation-delay: 0s;
    }

    .loading div:nth-child(1) {
      animation-delay: 0.1s;
    }

    .loading div:nth-child(2) {
      animation-delay: 0.2s;
    }

    .loading div:nth-child(3) {
      animation-delay: 0.3s;
    }

    .loading div:nth-child(4) {
      animation-delay: 0.4s;
    }

    .loading div:nth-child(5) {
      animation-delay: 1s;
    }

    .loading div {
      height: 23px;
      width: 23px;
      border-radius: 50%;
      transform: scale(0);
    }


    @keyframes scaling {

      0%,
      100% {
        transform: scale(0.2);
        background-color: #38f3b2;
      }

      40% {
        transform: scale(1);
        background-color: #147df5;
      }

      60% {
        transform: scale(1);
        background-color: #3d4ff5;
      }

      80% {
        transform: scale(1);
        background-color: #743df5;
      }
    }
  </style>
</head>

<body style="background-color: rgb(34, 33, 33);">
  <div class="container">
    <div class="logo">
      <img src="assets/assets/images/rpmwiki-logo-complex.svg" alt="">
      <p>RPMWiki</p>
    </div>
    <div class="loading">
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
    </div>
  </div>
  <!-- This script installs service_worker.js to provide PWA functionality to
       application. For more information, see:
       https://developers.google.com/web/fundamentals/primers/service-workers -->
  <script>
    var serviceWorkerVersion = null;
    var scriptLoaded = false;
    function loadMainDartJs() {
      if (scriptLoaded) {
        return;
      }
      scriptLoaded = true;
      var scriptTag = document.createElement('script');
      scriptTag.src = 'main.dart.js';
      scriptTag.type = 'application/javascript';
      document.body.append(scriptTag);
    }

    if ('serviceWorker' in navigator) {
      // Service workers are supported. Use them.
      window.addEventListener('load', function () {
        // Wait for registration to finish before dropping the <script> tag.
        // Otherwise, the browser will load the script multiple times,
        // potentially different versions.
        var serviceWorkerUrl = 'flutter_service_worker.js?v=' + serviceWorkerVersion;
        navigator.serviceWorker.register(serviceWorkerUrl)
          .then((reg) => {
            function waitForActivation(serviceWorker) {
              serviceWorker.addEventListener('statechange', () => {
                if (serviceWorker.state == 'activated') {
                  console.log('Installed new service worker.');
                  loadMainDartJs();
                }
              });
            }
            if (!reg.active && (reg.installing || reg.waiting)) {
              // No active web worker and we have installed or are installing
              // one for the first time. Simply wait for it to activate.
              waitForActivation(reg.installing || reg.waiting);
            } else if (!reg.active.scriptURL.endsWith(serviceWorkerVersion)) {
              // When the app updates the serviceWorkerVersion changes, so we
              // need to ask the service worker to update.
              console.log('New service worker available.');
              reg.update();
              waitForActivation(reg.installing);
            } else {
              // Existing service worker is still good.
              console.log('Loading app from service worker.');
              loadMainDartJs();
            }
          });

        // If service worker doesn't succeed in a reasonable amount of time,
        // fallback to plaint <script> tag.
        setTimeout(() => {
          if (!scriptLoaded) {
            console.warn(
              'Failed to load app from service worker. Falling back to plain <script> tag.',
            );
            loadMainDartJs();
          }
        }, 4000);
      });
    } else {
      // Service workers not supported. Just drop the <script> tag.
      loadMainDartJs();
    }
  </script>
</body>

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
  num priority = 0.5;
  final Map<String, String> _alternates = {};
  Map<String, String> get alternates => _alternates;
  void addAlternate(String language, String location) =>
      _alternates[language] = location;
}
