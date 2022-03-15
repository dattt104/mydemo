import 'package:business/video/screens/widget/play_pause_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:business/video/screens/widget/marquee_widget.dart';
import 'package:business/video/provider/video_page_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CollapsedPanelVideo extends StatelessWidget {
  const CollapsedPanelVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoPageProvider pageProvider = Provider.of<VideoPageProvider>(
      context,
    );
    if (pageProvider.getVideoSelected == null ||
        pageProvider.youtubePlayerController == null) {
      return const SizedBox();
    }
    String title = pageProvider.getVideoSelected!.title;
    String thumbnailUrl = pageProvider.getVideoSelected!.thumbnails.highResUrl;
    return Container(
      height: kBottomNavigationBarHeight * 1.15,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(left: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      fadeInDuration: const Duration(milliseconds: 400),
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarqueeWidget(
                          animationDuration: const Duration(seconds: 8),
                          backDuration: const Duration(seconds: 3),
                          pauseDuration: const Duration(seconds: 2),
                          direction: Axis.horizontal,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Product Sans',
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        ProgressBar(
                          controller: pageProvider.youtubePlayerController,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          PlayPauseWidget(
            controller: pageProvider.youtubePlayerController!,
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: () {
              pageProvider.closeVideoPanel();
            },
            child: Ink(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            ),
          ),
          const SizedBox(width: 12)
        ],
      ),
    );
  }
}
