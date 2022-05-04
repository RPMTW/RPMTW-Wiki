'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "404.html": "0722eabf30bf46fdae12442d1d891944",
"index.html": "deca19ce7993e9fde9509baeecbc9caa",
"/": "deca19ce7993e9fde9509baeecbc9caa",
"manifest.json": "3c63b819d82dab61dafd971074b130e6",
"favicon.png": "0dbadcc3aa4c8abce5898d835be6d9b1",
"version.json": "32b2ddc4d3638e3986b6d5bd403566ab",
"icons/Icon-512.png": "0dbadcc3aa4c8abce5898d835be6d9b1",
"icons/Icon-maskable-192.png": "0dbadcc3aa4c8abce5898d835be6d9b1",
"icons/Icon-maskable-512.png": "0dbadcc3aa4c8abce5898d835be6d9b1",
"icons/Icon-192.png": "0dbadcc3aa4c8abce5898d835be6d9b1",
"robots.txt": "c685f7dbc2c820ad06d4db555c08fe52",
"assets/FontManifest.json": "7d13f077d998bc71338c3b8e552c04cd",
"assets/NOTICES": "d81a6ebc855c604c2cdf8db19db54386",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "aa1ec80f1b30a51d64c72f669c1326a7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b37ae0f14cbc958316fac4635383b6e8",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5178af1d278432bec8fc830d50996d6f",
"assets/assets/fonts/NotoSansCJKtc-Regular.otf": "8c01889e307b677a5a32f455df84375d",
"assets/assets/images/rpmwiki-logo-complex.svg": "98d70422ca12b91fc9866cb9d70c6c18",
"assets/assets/images/RPMTW_Logo.gif": "281fc61a601f4f3d7876e2c3d13bd0ef",
"assets/assets/images/RPMWiki_Logo.svg": "e1044ca073f8a022dd8d0a0bbf0ebbac",
"assets/assets/images/cc-by-nc-sa.png": "80fb4a8b9dd7c600afda07b3d3c5efa4",
"assets/AssetManifest.json": "d02d14395748cff76a4e61eeb69ee1c4",
"canvaskit/profiling/canvaskit.js": "411ee45f5abb57975ee5243310c6953e",
"canvaskit/profiling/canvaskit.wasm": "c6681b1a749ad902eefcba11fed1cb3f",
"canvaskit/canvaskit.js": "f00de1f742223b7cf4cec1c2a0cd9764",
"canvaskit/canvaskit.wasm": "efe4a5da0205bb8d8c5aca7dad981abd",
"sitemap.xml": "29b5ba1da76b6617e7395d4b4e2973ab",
"CNAME": "48a07e0fbe719f96a25972eba047000d",
"main.dart.js": "3d4daadb72119904222d152f9532874e",
"mod/view/d992ecdc-0158-434b-bb88-9f2600f6ef7f.html": "3fc6fc43f40fbd62d5ff9e2a2428056e",
"mod/view/32de5000-62b0-479b-aacb-484a18b42a2c.html": "fa9c3a67449f9d1aaeb24139b12cec3a",
"mod/view/ae76a5fa-47ed-4f6d-a5cd-5cbe47d9df44.html": "f0dd2793eed5508ef031be446e33eddd",
"mod/view/0a65a89e-4048-4abe-9d5a-092f25d7d620.html": "295c58be064f2d4955bef7c533b35c2d",
"mod/view/4d96e967-5294-406f-92c8-d86bd368de30.html": "c70d42e5f27bffa700813298b7017d87",
"mod/view/587d4af1-99a5-4eb3-9a4f-583b0365954b.html": "22960d9d6c4f0631a42df7b61bfdd559",
"mod/view/bfd109ce-35ba-48da-8b91-5dd03a1f3632.html": "9ffc0fcd95a9df72024801683eac15b8",
"mod/view/6e3d5860-6851-40d1-a18f-27e26c7f2fae.html": "b5d1bbb79c131b65c57986abd2acf18c",
"mod/view/24559b32-9185-40f4-ba70-30d9bb655065.html": "ace5a807857b6556b888b9e1a6f6f84e",
"mod/view/f97958e1-7ab2-4a96-94ba-f4c5ad141578.html": "4d67265730d8296a5b2d016ab55d694b",
"mod/view/cb28b4ed-9ac1-48a2-9bd3-735c598e76de.html": "2553600640e7c10e4f6b53ae49d9720c",
"mod/view/d6e9de4e-e274-4566-b218-8a95c2d318a5.html": "fb4d7d854b99cc3d5e7f248c83f99239",
"mod/view/ae8a80d5-c34d-4814-8625-0b0503df64b1.html": "3e399e38203aa7367fee3f40aebfd426",
"mod/view/2f019e1c-b1e2-4f77-93cc-8aee18f4e3b1.html": "94cd41b0857a8c158cca96418e0da8b6",
"mod/view/3371caa0-4382-46b2-a8eb-09ac7cccfe50.html": "f70efd7dd4faed5cb9d25eb2625c06d0",
"mod/view/df67bd8f-8adb-450a-a1e5-d1f85744078c.html": "947f8d1ee0fe57a4ae2c84ff580c7e6d",
"mod/view/98e5a2d5-1e69-4585-a5b3-f389661dfca6.html": "dc6ef0f2abdc55bf7e1216615ca81ebe",
"mod/view/1089cb0b-363f-4487-a79c-36d04a5afa2e.html": "3dafd248baa4f23f89f704e1a91dcd8d",
"mod/view/cc9fd773-9490-402d-881f-466574768a14.html": "5edde59f7c51c6f635f2d352c456d193",
"mod/view/86dd328a-0b8d-4841-81e7-61c6faad8268.html": "1af95e2ea1857406fb0a62ecd2f83a3c",
"mod/view/ec2ca4f9-703a-41f2-b67c-27436f3b4c56.html": "97cfa547ca9cfbc6f1ad6256aba7ccb1",
"mod/view/e41635cf-473b-4fb7-bb46-714e1dac73ed.html": "2a18aa7a6cff124df9f951e1d261f075",
"mod/view/2cc5d055-ae7a-4491-9050-7900121cbfca.html": "fe599dfa62f172786892b8f0b3f2267e",
"mod/view/a46b8125-38bf-42bb-8967-b4ae42267d3b.html": "74edd6ee49ab23cc361e01f449c5ff7d",
"mod/view/8c48c153-c2a9-4085-9133-eb39ab9e1365.html": "8709fb41adb9ded2d83d004f39958999",
"mod/view/f7ccb521-00d3-4edf-8ec1-4b3e4901065a.html": "333c49c9834feaed8462085f706d170c",
"mod/view/faa950dc-48ae-46d8-be93-47b5503ab333.html": "9a1eb5cc5763f25d57bc2c653e2cf00c",
"mod/view/bb54015b-cf36-411b-a2ef-e2ba63ed26f0.html": "172b151b762166e62b30837874ac112a",
"mod/view/3c97ccf0-b370-4df7-a162-e978db4d02ab.html": "f91a94da69d72619ab815d7fffa8ea5d",
"mod/view/c37d2982-e3d9-4448-8f57-2df67872cdf2.html": "fe7945938c36c60ea58dc89e04de3ef3",
"mod/view/4928f70d-e72d-4b2e-9e36-be383a1061eb.html": "83dee5359bb18173c29ccdb320486ae0",
"mod/view/3f00814d-4807-4988-81de-0b36c5cc624c.html": "842d8994de3ae386a380d850508c463c",
"mod/view/9350dcd7-acda-4905-a9cd-8c08c8f3f26b.html": "c6dd9a52bcf268aba2077acc088ca66f",
"mod/view/41dfa230-4b9b-4028-91f8-cd889c9bbd9b.html": "0a9efcababf588e7788ffcd2298f6ac4",
"mod/view/1358cd52-801a-4386-9359-90765daa9e1c.html": "15af32ca4968193cad2ea8c7951612b3",
"mod/view/934e263c-e62b-48b3-b284-de48a3a4d738.html": "6dbf21c4f0b4184a82d439cbcdd96625",
"mod/view/b5ad76fe-1437-46b2-81fe-c9b4d639eaad.html": "13633cb92b077099066012aee34854f9",
"mod/view/3e387e93-c951-4571-8a6d-b39eaa995919.html": "12e9d55d7bdff3cab932c38f91716e70",
"mod/view/cd6b20f5-7969-44c0-a0a7-0501b023d788.html": "d375146b37558899e6c121d3661b41e4",
"mod/view/2ee607d6-1fe9-4d16-9428-41c6ca015c2c.html": "88eda7c706596b776aa340a3714281fa",
"mod/view/cb6d4184-e200-495d-845d-c82d32428eb9.html": "ad1b0c7dfc9edc4357008d536b41727e",
"mod/view/31f140c9-33cc-4ec6-b87f-81e1a330d340.html": "ed30b566a7b10ac81bd9bc37ce268b42",
"mod/view/342f2f12-5d56-40e2-921a-31ceba04a931.html": "5f71086ed226a609016eed540c885e6b",
"mod/view/23e70435-75da-499f-ad7f-547ae6d6c500.html": "d43f71f90c69ee28ba7f45148f8a99ee",
"mod/view/14555292-c7bb-4739-9f9b-f7f3e4fa767a.html": "6ac3222f5c44a2bdd123440a401ef6aa",
"mod/view/fe7b4c8c-b98c-4546-a270-ef11bdacab43.html": "057e07c386a13391e7b95afed82c1d18",
"mod/view/ac1447aa-73c2-4a67-99ee-ede96109ca22.html": "5c3bc7d7bf2e8881cfaa6c021aa99160"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
