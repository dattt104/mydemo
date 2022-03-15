import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PopupMenu extends StatelessWidget {
  final Video video;
  final Function(dynamic)? onDelete;
  const PopupMenu({
    Key? key,
    required this.video,
    this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlexiblePopupMenu(
      items: [
        FlexiblePopupItem(
          title: 'Chia sẻ',
          value: 'Share',
        ),
        FlexiblePopupItem(
          title: 'Sao chép link',
          value: 'CopyLink',
        ),
      ],
      onItemTap: (String value) async {
        switch (value) {
          case 'Share':
            Share.share(
              video.url,
            );
            break;
          case 'CopyLink':
            Clipboard.setData(
              ClipboardData(
                text: video.url,
              ),
            );
            break;
        }
      },
      borderRadius: 10,
      child: Container(
        padding: const EdgeInsets.all(4),
        color: Colors.transparent,
        child: const Icon(Icons.more_vert_rounded, size: 16),
      ),
    );
  }
}

class FlexiblePopupItem {
  String title;
  String value;

  FlexiblePopupItem({
    required this.title,
    required this.value,
  });
}

class FlexiblePopupMenu extends StatelessWidget {
  final Widget child;
  final List<FlexiblePopupItem> items;
  final Function(String) onItemTap;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  const FlexiblePopupMenu({
    Key? key,
    required this.child,
    required this.items,
    required this.onItemTap,
    this.borderRadius,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        showMenu<String>(
          color: Theme.of(context).popupMenuTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius == null
                ? BorderRadius.zero
                : BorderRadius.circular(borderRadius!),
          ),
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            0,
            0,
          ),
          items: items.map(
            (e) {
              return PopupMenuItem<String>(
                child: Text(
                  e.title,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 14),
                ),
                value: e.value,
              );
            },
          ).toList(),
        ).then(
          (value) {
            onItemTap(value!);
          },
        );
      },
      child: Padding(
        padding: padding == null ? EdgeInsets.zero : padding!,
        child: child,
      ),
    );
  }
}
