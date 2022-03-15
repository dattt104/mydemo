import 'package:animations/animations.dart';
import 'package:business/demo_screen.dart';
import 'package:flutter/material.dart';

import 'package:business/video/screens/collapsed_panel.dart';
import 'package:business/video/screens/expanded_panel.dart';
import 'package:business/video/provider/video_page_provider.dart';

import 'package:provider/provider.dart';
import 'package:business/video/screens/my_video_screen.dart';
import 'package:business/video/screens/widget/fancy_scaffold.dart';
import 'package:business/video/screens/widget/navigation_bar.dart';

class MainTab extends StatefulWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int _screenIndex = 0;

  final GlobalKey<ScaffoldState> _internalScaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _screenIndex = 0;
    WidgetsBinding.instance!.renderView.automaticSystemUiAdjustment = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: _libBody(),
    );
  }

  Widget _libBody() {
    return FancyScaffold(
      backgroundColor: Theme.of(context).cardColor,
      resizeToAvoidBottomInset: false,
      internalKey: _internalScaffoldKey,
      body: SafeArea(
        child: Consumer<VideoPageProvider>(
          builder: (context, pageProvider, child) {
            return WillPopScope(
              onWillPop: () {
                if (pageProvider.fwController.isAttached &&
                    pageProvider.fwController.isPanelOpen) {
                  pageProvider.fwController.close();
                  return Future.value(false);
                } else if (pageProvider.slidingPanelOpen ?? false) {
                  pageProvider.slidingPanelOpen = false;
                  pageProvider.fwController.close();
                  return Future.value(false);
                } else if (_screenIndex != 0) {
                  setState(() => _screenIndex = 0);
                  return Future.value(false);
                  // } else if (manager.youtubeSearch != null) {
                  //   manager.youtubeSearch = null;
                  //   manager.setState();
                  //   return Future.value(false);
                  // } else if (_screenIndex == 0 &&
                  //     manager.currentHomeTab != HomeScreenTab.Trending) {
                  //   manager.currentHomeTab = HomeScreenTab.Trending;
                  //   return Future.value(false);
                } else {
                  return Future.value(true);
                }
              },
              child: child!,
            );
          },
          child: PageTransitionSwitcher(
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
            duration: const Duration(
              milliseconds: 300,
            ),
            child: _renderTabView(),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _screenIndex,
        onItemTap: (int index) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          setState(
            () => _screenIndex = index,
          );
        },
      ),
      floatingWidgetTwins: _currentFloatingTwins(),
      floatingWidgetConfig: FloatingWidgetConfig(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      floatingWidgetController: _currentFloatingWidgetController(),
    );
  }

  FloatingWidgetTwins? _currentFloatingTwins() {
    VideoPageProvider pageProvider = Provider.of<VideoPageProvider>(
      context,
    );
    if (pageProvider.getVideoSelected != null) {
      return FloatingWidgetTwins(
        expanded: const ExpandedPanelVideo(),
        collapsed: const CollapsedPanelVideo(),
      );
    }
    return null;
  }

  FloatingWidgetController? _currentFloatingWidgetController() {
    VideoPageProvider pageProvider = Provider.of<VideoPageProvider>(context);
    if (pageProvider.getVideoSelected != null) {
      return pageProvider.fwController;
    }
    return null;
  }

  Widget _renderTabView() {
    if (_screenIndex == 0) {
      return const MyVideoScreen();
    }
    if (_screenIndex == 1) {
      return const DemoScreen();
    }
    return Container();
  }
}
