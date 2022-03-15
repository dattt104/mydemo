import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayPauseWidget extends StatefulWidget {
  final YoutubePlayerController controller;

  const PlayPauseWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _PlayPauseWidgetState createState() => _PlayPauseWidgetState();
}

class _PlayPauseWidgetState extends State<PlayPauseWidget>
    with TickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _animController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addListener(_playPauseListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_playPauseListener);
    _animController.dispose();
    super.dispose();
  }

  bool _rebuild = false;
  void _playPauseListener() {
    _controller.value.isPlaying
        ? _animController.forward()
        : _animController.reverse();

    if (_controller.value.playerState == PlayerState.playing ||
        _controller.value.playerState == PlayerState.paused) {
      if (!_rebuild) {
        _rebuild = true;
        setState(() {});
      }
    } else if (_controller.value.playerState == PlayerState.buffering) {
      if (_rebuild) {
        _rebuild = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _playerState = _controller.value.playerState;
    if ((!_controller.flags.autoPlay && _controller.value.isReady) ||
        _playerState == PlayerState.playing ||
        _playerState == PlayerState.paused) {
      return Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          onTap: () => _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play(),
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animController.view,
            color: Colors.black,
            size: 24.0,
          ),
        ),
      );
    }
    if (_controller.value.hasError) {
      return const SizedBox();
    }

    return const SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Colors.black,
        ),
        strokeWidth: 2.0,
      ),
    );
  }
}
