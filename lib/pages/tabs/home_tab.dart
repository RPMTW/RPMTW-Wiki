import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/mouse_scale.dart';
import 'package:rpmtw_wiki/widget/row_scroll_view.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _ModTabState createState() => _ModTabState();
}

class _ModTabState extends State<HomeTab> {
  bool loading = true;

  late final List<MinecraftMod> mods;

  @override
  void initState() {
    super.initState();

    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    apiClient.minecraftResource
        .search(sort: ModSortType.viewCount, limit: 5)
        .then((value) {
      setState(() {
        mods = value;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        loading: loading,
        builder: (context) {
          return Column(
            children: [
              SizedBox(height: kSplitHight),
              SEOText(localizations.homePopularMods,
                  style: const TextStyle(
                    fontSize: 26,
                  )),
              _ModShowcase(mods: mods)
            ],
          );
        });
  }
}

class _ModShowcase extends StatefulWidget {
  final List<MinecraftMod> mods;
  const _ModShowcase({Key? key, required this.mods}) : super(key: key);

  @override
  State<_ModShowcase> createState() => _ModShowcaseState();
}

class _ModShowcaseState extends State<_ModShowcase> {
  late List<bool> _isSelected;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    _isSelected = List.generate(widget.mods.length, (_) => false);
    _isSelected[0] = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utility.getScreenSize(context);
    double imageSize = kIsDesktop ? 200 : 100;
    double imageScale = 1.3;
    double imageMaxSize = imageSize * imageScale;

    return Column(
      children: [
        SizedBox(
          height: imageMaxSize,
          child: CarouselSlider.builder(
            itemCount: widget.mods.length,
            itemBuilder: (context, index, pageViewIndex) {
              MinecraftMod mod = widget.mods[index];
              double moreInfoWidth = kIsDesktop ? 200.0 : 0.0;

              return SizedBox(
                width: imageMaxSize + moreInfoWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: MouseScale(
                        maxScale: imageScale,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: mod.imageWidget(
                                width: imageSize,
                                height: imageSize,
                              ) ??
                              Icon(Icons.image, size: imageSize),
                        ),
                      ),
                      onTap: () {
                        navigation.pushNamed("/mod/view/${mod.uuid}");
                      },
                    ),
                    if (kIsDesktop) SizedBox(width: kSplitWidth),
                    if (kIsDesktop)
                      SizedBox(
                        width: moreInfoWidth,
                        height: imageMaxSize,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SEOSelectableText(mod.name),
                            if (mod.translatedName != null)
                              SEOSelectableText(mod.translatedName!),
                            ...?mod.description != null
                                ? [
                                    SizedBox(height: kSplitHight),
                                    SEOSelectableText(
                                      mod.description!,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white70),
                                    )
                                  ]
                                : null
                          ],
                        ),
                      )
                  ],
                ),
              );
            },
            options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                height: imageSize,
                onPageChanged: (index, reason) {
                  setState(() {
                    for (int i = 0; i < widget.mods.length; i++) {
                      if (i == index) {
                        _isSelected[i] = true;
                      } else {
                        _isSelected[i] = false;
                      }
                    }
                  });
                }),
            carouselController: _controller,
          ),
        ),
        Center(
          heightFactor: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 8,
                right: screenSize.width / 8,
              ),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height / 50,
                    bottom: screenSize.height / 50,
                  ),
                  child: RowScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            kIsMobile ? screenSize.width : double.infinity,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < widget.mods.length; i++)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: () {
                                    _controller.animateToPage(i);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height / 80,
                                        bottom: screenSize.height / 90),
                                    child: SEOText(
                                      widget.mods[i].name,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .button!
                                            .color,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: _isSelected[i],
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 400),
                                    opacity: _isSelected[i] ? 1 : 0,
                                    child: Container(
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      width: screenSize.width / 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
