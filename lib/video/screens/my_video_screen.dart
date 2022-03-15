import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:business/video/provider/video_page_provider.dart';
import 'package:business/video/screens/widget/alias_widget.dart';
import 'package:business/video/screens/widget/auto_hide_scaffold.dart';
import 'package:business/video/screens/video_cell.dart';

class MyVideoScreen extends StatefulWidget {
  const MyVideoScreen({Key? key}) : super(key: key);

  @override
  _MyVideoScreenState createState() => _MyVideoScreenState();
}

class _MyVideoScreenState extends State<MyVideoScreen> {
  late VideoPageProvider _videoPageProvider;

  @override
  void initState() {
    _videoPageProvider = Provider.of<VideoPageProvider>(
      context,
      listen: false,
    );
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        _videoPageProvider.getChannelInfo();
        _videoPageProvider.getVidChannel();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPageProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        return Stack(
          children: [
            AutoHideScaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).cardColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).cardColor,
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    'Video hôm nay!',
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
              ),
              body: Builder(
                builder: (context) {
                  return PageTransitionSwitcher(
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return FadeThroughTransition(
                        fillColor: Theme.of(context).cardColor,
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                    duration: const Duration(milliseconds: 300),
                    child: _videoPageProvider.getVidChannels.isNotEmpty
                        ? VideoCell(
                            scaffoldKey: const Key('k_video'),
                            videos: provider.getVidChannels,
                            onTap: (video, index) async {
                              provider.setVideoSelected(
                                provider.getVidChannels[index],
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: index == 0 ? 12 : 0,
                                ),
                                child: const AliasWidget(),
                              );
                            },
                          ),
                  );
                },
              ),
            ),
            if (provider.lockLoadingScreen) _buildLoading(),
          ],
        );
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              Colors.black,
            ),
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
