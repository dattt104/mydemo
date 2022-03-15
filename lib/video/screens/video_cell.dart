import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:business/video/screens/widget/alias_widget.dart';
import 'package:business/video/screens/widget/fadein.dart';
import 'package:business/video/screens/widget/popup_menu.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoCell extends StatelessWidget {
  final List<Video> videos;
  final Function(Video, int) onTap;
  final bool shrinkWrap;
  final bool removePhysics;
  final bool topPadding;
  final Key? scaffoldKey;
  const VideoCell({
    Key? key,
    required this.videos,
    required this.onTap,
    this.shrinkWrap = false,
    this.removePhysics = false,
    this.topPadding = true,
    this.scaffoldKey,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: videos.isNotEmpty
          ? ListView.builder(
              physics: removePhysics
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              shrinkWrap: shrinkWrap,
              padding: const EdgeInsets.only(
                bottom: 100.0,
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                Video video = videos[index];
                return FadeInTransition(
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () => onTap(video, index),
                    child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: topPadding
                              ? index == 0
                                  ? 12
                                  : 0
                              : 0,
                          bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: FadeInImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      placeholder:
                                          MemoryImage(kTransparentImage),
                                      image: NetworkImage(
                                        video.thumbnails.highResUrl,
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Text(
                                      _getTimeDuration(video),
                                      style: const TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    _displayName(video),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Product Sans',
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    _displayUploaderName(video),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!
                                          .withOpacity(0.8),
                                      fontFamily: 'Product Sans',
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenu(
                            video: video,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              shrinkWrap: shrinkWrap,
              padding: EdgeInsets.zero,
              itemCount: 10,
              itemBuilder: (context, index) {
                return const AliasWidget();
              },
            ),
    );
  }

  String _getTimeDuration(Video video) {
    try {
      return '${Duration(seconds: video.duration!.inSeconds).inMinutes}:' +
          Duration(seconds: video.duration!.inSeconds)
              .inSeconds
              .remainder(60)
              .toString()
              .padRight(2, '0');
    } catch (e) {
      return '--:--';
    }
  }

  String _displayName(Video video) {
    return video.title;
  }

  String _displayUploaderName(Video video) {
    try {
      String author = video.author;
      String viewCount = NumberFormat.compact().format(
        video.engagement.viewCount,
      );
      return author + (viewCount == '0' ? '' : ' • ' + viewCount + ' Views');
    } catch (e) {
      return '';
    }
  }
}
