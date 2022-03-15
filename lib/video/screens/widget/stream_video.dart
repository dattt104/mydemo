import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:business/video/provider/video_page_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StreamVideo extends StatefulWidget {
  final Video video;
  const StreamVideo({
    Key? key,
    required this.video,
  }) : super(key: key);
  @override
  _StreamVideoState createState() => _StreamVideoState();
}

class _StreamVideoState extends State<StreamVideo> {
  late YoutubePlayerController _controller;

  final List<String> _ids = [];

  late VideoPageProvider _videoPageProvider;

  _getRelatedIds() {
    for (var vid in _videoPageProvider.getVidChannels) {
      _ids.add(vid.id.value);
    }
  }

  @override
  void initState() {
    super.initState();
    _videoPageProvider = Provider.of<VideoPageProvider>(
      context,
      listen: false,
    );

    _controller = _videoPageProvider.youtubePlayerController!;
    _getRelatedIds();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(
          DeviceOrientation.values,
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              widget.video.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _videoPageProvider.updatePlayerReady(true);
        },
        onEnded: (data) {
          try {
            int nextId = (_ids.indexOf(data.videoId) + 1) % _ids.length;
            _controller.load(
              _ids[nextId],
            );
            _videoPageProvider.setVideoSelected(
              _videoPageProvider.getVidChannels[nextId],
              keepScreen: true,
            );
            // ignore: empty_catches
          } catch (e) {}
        },
      ),
      builder: (context, player) {
        return const SizedBox();
      },
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
      child: Material(
        color: Colors.black,
        child: child,
      ),
    );
  }
}
