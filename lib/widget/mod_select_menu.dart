import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_text_field.dart';

class ModSelectMenu {
  final String? title;
  final void Function(MinecraftMod mod)? onSelected;
  const ModSelectMenu({Key? key, this.title, this.onSelected});

  Future<void> show(BuildContext context) async {
    StateSetter? setFilterState;
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + Offset.zero,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    RPMTWApiClient apiClient = RPMTWApiClient.instance;

    String? filter;
    List<PopupMenuEntry<Widget>> items = [
      if (title != null)
        _PopupMenuItem(
            child: Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        )),
      _PopupMenuItem(
          child: Row(
        children: [
          SizedBox(width: kSplitWidth / 2),
          const Icon(Icons.search),
          SizedBox(width: kSplitWidth / 2),
          Expanded(
            child: RPMTextField(
              hintText: localizations.addModBaseCheckExistsHint,
              onChanged: (value) {
                setFilterState?.call(() {
                  filter = value;
                });
              },
            ),
          ),
          SizedBox(width: kSplitWidth / 2),
        ],
      )),
      _PopupMenuItem(
          child: StatefulBuilder(builder: (context, _setFilterState) {
        setFilterState = _setFilterState;
        return FutureBuilder<List<MinecraftMod>>(
            future: apiClient.minecraftResource.search(filter: filter),
            builder: (context, snapshot) {
              if (!snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done) {
                List<MinecraftMod> mods = snapshot.data!;
                return SizedBox(
                  width: 200,
                  height: mods.length * 68.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mods.length,
                      itemBuilder: ((context, index) {
                        MinecraftMod mod = mods[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelected?.call(mod);
                          },
                          leading: mod.imageWidget() ?? const Icon(Icons.image),
                          title:
                              Tooltip(message: mod.uuid, child: Text(mod.name)),
                          subtitle: mod.id != null ? Text(mod.id!) : null,
                        );
                      })),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      }))
    ];

    await showMenu(context: context, position: position, items: items);
  }
}

class _PopupMenuItem<T> extends PopupMenuEntry<T> {
  const _PopupMenuItem({
    Key? key,
    this.value,
    this.height = kMinInteractiveDimension,
    this.onTap,
    required this.child,
  }) : super(key: key);

  final T? value;

  /// Defaults to [kMinInteractiveDimension] pixels.
  @override
  final double height;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  _PopupMenuItemState<T, _PopupMenuItem<T>> createState() =>
      _PopupMenuItemState<T, _PopupMenuItem<T>>();
}

class _PopupMenuItemState<T, W extends _PopupMenuItem<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    widget.onTap?.call();

    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: widget.child,
      onTap: widget.onTap != null ? handleTap : null,
    );
  }
}
