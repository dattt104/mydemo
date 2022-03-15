import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:business/video/screens/video_cell.dart';
import 'package:business/video/provider/video_page_provider.dart';
import 'package:business/video/screens/widget/alias_widget.dart';
import 'package:business/video/screens/widget/measure_size.dart';
import 'package:business/video/screens/widget/stream_video.dart';
import 'package:transparent_image/transparent_image.dart';
import 'widget/details.dart';

class ExpandedPanelVideo extends StatefulWidget {
  const ExpandedPanelVideo({Key? key}) : super(key: key);

  @override
  _ExpandedPanelVideoState createState() => _ExpandedPanelVideoState();
}

class _ExpandedPanelVideoState extends State<ExpandedPanelVideo>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Player Height
  double playerHeight = 0;

  // BottomSheet controller
  PersistentBottomSheetController? _bottomSheetController;

  // Scroll Controller
  late ScrollController _scrollController;

  // Restoring Scroll position
  bool _restoringScroll = false;

  // Animation controller for hiding Details & Engagement on scroll
  late AnimationController _animationController;

  late VideoPageProvider _videoPageProvider;

  @override
  void initState() {
    super.initState();
    _videoPageProvider = Provider.of<VideoPageProvider>(
      context,
      listen: false,
    );
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        if (!_restoringScroll) {
          _animationController.value =
              1 - (_scrollController.position.pixels.clamp(0, 200)) / 200;
        }
      },
    );
    _animationController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bottomSheetController != null &&
        _videoPageProvider.fwController.panelPosition < 1) {
      try {
        _bottomSheetController!.close();
      } catch (_) {}
      setState(
        () => _bottomSheetController = null,
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBodyView(),
    );
  }

  Widget _buildBodyView() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll is ScrollEndNotification) {
          if (_scrollController.position.pixels < 100) {
            _animationController.animateTo(1).then(
              (_) {
                _restoringScroll = true;
                _scrollController
                    .animateTo(0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.ease)
                    .then(
                      (_) => _restoringScroll = false,
                    );
              },
            );
          } else {
            _animationController.animateTo(0).then(
              (_) {
                _restoringScroll = true;
                if (_scrollController.position.pixels < 200) {
                  _scrollController
                      .animateTo(200,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.ease)
                      .then(
                        (_) => _restoringScroll = false,
                      );
                }
              },
            );
          }
        }
        return false;
      },
      child: _portraitVideoPage(),
    );
  }

  Widget _portraitVideoPage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.bottom,
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                children: <Widget>[
                  _portraitMainBody(),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          _playlistChannelVideos(
                            _videoPageProvider,
                            topPadding: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.bottom,
          color: Theme.of(context).cardColor,
        )
      ],
    );
  }

  Widget _portraitMainBody() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).padding.top,
          width: double.infinity,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: MeasureSize(
              onChange: (Size size) {
                playerHeight = size.height;
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _videoPageProvider.getVideoSelected != null
                      ? _videoPlayerWidget()
                      : _videoLoading(),
                ),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: (_animationController.value -
                          (1 - _animationController.value)) >
                      0
                  ? (_animationController.value -
                      (1 - _animationController.value))
                  : 0,
              child: Align(
                heightFactor: _animationController.value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 12),
              _videoDetails(),
              const Divider(height: 1),
            ],
          ),
        ),
        _channelInfo(),
      ],
    );
  }

  Widget _videoPlayerWidget() {
    return StreamVideo(
      video: _videoPageProvider.getVideoSelected!,
    );
  }

  Widget _videoDetails() {
    return Consumer<VideoPageProvider>(
      builder: (context, provider, child) {
        return VideoDetails(
          viewModel: provider,
          onShare: () {
            Share.share(
              _videoPageProvider.getVideoSelected!.url,
            );
          },
        );
      },
    );
  }

  Widget _channelInfo() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage(
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(
                      _videoPageProvider.channelInfo!.logoUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _videoPageProvider.channelInfo!.title,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Product Sans',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _videoPageProvider.getVidChannels.length.toString() +
                          ' video' +
                          (_videoPageProvider.getVidChannels.length == 1
                              ? ''
                              : 's'),
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12)
          ],
        ),
        const Divider(height: 1)
      ],
    );
  }

  Widget _videoLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Colors.white,
        ),
      ),
    );
  }

  Widget _playlistChannelVideos(
    VideoPageProvider pageProvider, {
    bool topPadding = false,
  }) {
    return Consumer<VideoPageProvider>(
      builder: (context, provider, child) {
        if (_videoPageProvider.getVidChannels.isNotEmpty) {
          return VideoCell(
            scaffoldKey: const Key('vid_cell'),
            videos: _videoPageProvider.getVidChannels,
            shrinkWrap: true,
            removePhysics: true,
            topPadding: topPadding,
            onTap: (stream, index) {
              _videoPageProvider.setVideoSelected(
                _videoPageProvider.getVidChannels[index],
                keepScreen: true,
              );
            },
          );
        }
        return ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
              child: const AliasWidget(),
            );
          },
        );
      },
    );
  }
}
