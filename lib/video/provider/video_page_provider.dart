import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:business/video/screens/widget/fancy_scaffold.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPageProvider extends ChangeNotifier {
  final String _myChannelId = 'UCkgdDBHO7zl3tWIjldQeK7g';
  // 'UC_JElDDruEOg9KlzSE7CJOQ';
  // Slidable panel controller
  late FloatingWidgetController fwController;

  // SlidingPanel Open/Closed Status
  bool? slidingPanelOpen;

  VideoPageProvider() {
    fwController = FloatingWidgetController();
    slidingPanelOpen = false;
  }

  /// Channel infor
  Channel? channelInfo;

  /// Playlist video channel
  final List<Video> _vidChannels = <Video>[];
  List<Video> get getVidChannels => _vidChannels;

  /// Video selected from list
  Video? _videoSelected;
  Video? get getVideoSelected => _videoSelected;

  /// Player controller
  YoutubePlayerController? youtubePlayerController;

  /// Player state status
  PlayerState? _playerState;
  PlayerState? get getPlayerState => _playerState;

  /// Player is start
  bool _playerIsReady = false;

  /// Lock Screen
  bool lockLoadingScreen = false;

  setVideoSelected(
    Video video, {
    bool keepScreen = false,
  }) {
    _videoSelected = video;
    updLockLoadingScreen(true);
    updatePlayerReady(false);
    if (youtubePlayerController == null) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: video.id.value,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: true,
          enableCaption: true,
        ),
      )..addListener(
          _onListenerPlayer,
        );
    } else {
      youtubePlayerController!.load(
        video.id.value,
      );
    }
    setState();
    if (!keepScreen) {
      Future.delayed(const Duration(milliseconds: 100)).then(
        (value) {
          /// Mặc định thu nhỏ màn hình
          if (fwController.isAttached) fwController.close();
          setState();
        },
      );
    }
  }

  getChannelInfo() {
    var yt = YoutubeExplode();
    yt.channels.get(_myChannelId).then(
      (Channel channel) {
        channelInfo = channel;
        setState();
      },
    );
  }

  getVidChannel() async {
    int index = 0;
    var yt = YoutubeExplode();
    _vidChannels.clear();
    await for (Video video in yt.channels.getUploads(_myChannelId)) {
      index++;
      _vidChannels.add(video);

      /// Only take 50 items if above 50.
      if (index >= 50) {
        setState();
        return;
      }
    }
    setState();
  }

  void _onListenerPlayer() {
    if (_playerIsReady && youtubePlayerController != null) {
      _playerState = youtubePlayerController!.value.playerState;
    }
    updLockLoadingScreen(false);
  }

  updatePlayerReady(
    bool newValue,
  ) {
    if (_playerIsReady != newValue) {
      _playerIsReady = newValue;
      setState();
    }
  }

  updLockLoadingScreen(bool newValue) {
    if (lockLoadingScreen != newValue) {
      lockLoadingScreen = newValue;
      setState();
    }
  }

  void closeVideoPanel() {
    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
      youtubePlayerController = null;
    }
    _videoSelected = null;
    setState();
  }

  void setState() {
    notifyListeners();
  }
}
