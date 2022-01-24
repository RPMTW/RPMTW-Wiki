import 'dart:io';

import 'package:path/path.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

void main(List<String> arguments) async {
  RPMTWApiClient.init();
  RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
  int skip = 0;

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

      File file = File(join(Directory.current.parent.parent.path, "web", "mod",
          "view", "${mod.uuid}.html"));
      await file.create(recursive: true);
      await file.writeAsString(html);
    }

    if (mods.length < 50) {
      print("test");
      exit(0);
    }

    skip += 50;
  }
}
