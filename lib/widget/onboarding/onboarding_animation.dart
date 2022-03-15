library onboarding_animation;

import 'package:business/widget/onboarding/effect/expanding_dots_effect.dart';
import 'package:business/widget/onboarding/widget/smoot_page_indicator.dart';
import 'package:flutter/material.dart';

class OnBoardingAnimation extends StatefulWidget {
  /// This parameter is required. need to provide list of [Widget] user wants to show on onBoarding.
  final List<Widget> pages;

  /// This parameter is used to set the offset of the indicator.
  final double indicatorOffset;

  /// Set the width of the the indicator's dot.
  final double indicatorDotWidth;

  /// Set the height of indicator's dot.
  final double indicatorDotHeight;

  /// Using this parameter user can define the space between the dots of indicator.
  final double indicatorDotSpacing;

  /// Is use to set the radius of the circle shown in the indicator.
  final double indicatorDotRadius;

  /// This is use to set the color of the inactive(unselected) dot color.
  final Color indicatorInActiveDotColor;

  /// This is use to set the color of the active(selected) dot color.
  final Color indicatorActiveDotColor;

  /// [indicatorStrokeWidth] is use to set the width of the stroke if the [PaintStyle] is selected to the stroke.
  final double indicatorStrokeWidth;

  /// This is an enum which is use to select the position of an indicator.
  final IndicatorPosition indicatorPosition;

  /// [indicatorExpansionFactor] is multiplied by [indicatorDotWidth] to resolve
  /// the width of the expanded dot.
  final double indicatorExpansionFactor;

  /// The maximum scale the dot will hit while jumping.
  final double indicatorJumpScale;

  /// The vertical offset of the jumping dot.
  final double indicatorVerticalOffset;

  /// [indicatorPaintStyle] is use to select between the fill and the stroke style.
  final PaintingStyle indicatorPaintStyle;

  /// Inactive dots paint style (fill/stroke) defaults to fill.
  final PaintingStyle indicatorActivePaintStyle;

  /// This is ignored if [indicatorActivePaintStyle] is PaintStyle.fill.
  final double indicatorActiveStrokeWidth;

  /// [indicatorScale] is multiplied by [indicatorDotWidth] to resolve
  /// active dot scaling.
  final double indicatorScale;

  /// [indicatorActiveDotScale] is multiplied by [indicatorDotWidth] to resolve
  /// active dot scaling.
  final double indicatorActiveDotScale;

  /// The max number of dots to display at a time
  /// if count is <= [maxVisibleDots] [indicatorMaxVisibleDots] = count
  /// must be an odd number that's >= 5.
  final int indicatorMaxVisibleDots;

  /// If True the old center dot style will be used.
  final bool indicatorFixedCenter;

  const OnBoardingAnimation({
    required this.pages,
    this.indicatorOffset = 10.0,
    this.indicatorDotWidth = 7.0,
    this.indicatorDotHeight = 7.0,
    this.indicatorDotSpacing = 8.0,
    this.indicatorDotRadius = 11.0,
    this.indicatorJumpScale = 1.4,
    this.indicatorVerticalOffset = 0.0,
    this.indicatorInActiveDotColor = Colors.grey,
    this.indicatorActiveDotColor = Colors.black,
    this.indicatorPaintStyle = PaintingStyle.fill,
    this.indicatorActivePaintStyle = PaintingStyle.fill,
    this.indicatorScale = 1.4,
    this.indicatorActiveDotScale = 1.3,
    this.indicatorMaxVisibleDots = 5,
    this.indicatorFixedCenter = false,
    this.indicatorActiveStrokeWidth = 1.0,
    this.indicatorExpansionFactor = 3.0,
    this.indicatorStrokeWidth = 1.0,
    this.indicatorPosition = IndicatorPosition.bottomCenter,
    Key? key,
  }) : super(key: key);

  @override
  _OnBoardingAnimationState createState() => _OnBoardingAnimationState();
}

class _OnBoardingAnimationState extends State<OnBoardingAnimation> {
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<double> _pageIndex = ValueNotifier(0.0);

  /// Initialize the listener to add page listener.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _pageController.addListener(_listener);
    });
  }

  /// For disposing the PageController and removing the page listener.
  @override
  void dispose() {
    super.dispose();
    _pageController.removeListener(_listener);
    _pageController.dispose();
  }

  /// Main body for onBoarding animation.
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ValueListenableBuilder<double>(
          builder: (_, indexValue, __) {
            return PageView.builder(
              itemCount: widget.pages.length,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                /// TweenAnimationBuilder to smoothen the animation.
                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 140),
                  tween: Tween<double>(
                    begin: ((((index - indexValue) * 100.0) *
                            ((index - indexValue).abs() / 40)) /
                        100.0),
                    end: ((((index - indexValue) * 100.0) *
                            ((index - indexValue).abs() / 40)) /
                        100.0),
                  ),
                  builder: (_, double rotation, _child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .1)
                        ..rotateY(rotation),
                      alignment: FractionalOffset.center,
                      child: widget.pages[index],
                    );
                  },
                );
              },
              onPageChanged: (index) => _pageIndex.value = index.toDouble(),
            );
          },
          valueListenable: _pageIndex,
        ),
        Align(
          alignment: _getIndicatorPosition()!,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.pages.length,
              effect: _getIndicatorType(),
            ),
          ),
        )
      ],
    );
  }

  /// This method listen to the page changes to give the position value of the pages using [PageController].
  void _listener() {
    _pageIndex.value = _pageController.page!;
  }

  /// This method is used to set the position of the page indicator.
  Alignment? _getIndicatorPosition() {
    switch (widget.indicatorPosition) {
      case IndicatorPosition.center:
        return Alignment.center;
      case IndicatorPosition.topCenter:
        return Alignment.topCenter;
      case IndicatorPosition.topRight:
        return Alignment.topRight;
      case IndicatorPosition.topLeft:
        return Alignment.topLeft;
      case IndicatorPosition.bottomCenter:
        return Alignment.bottomCenter;
      case IndicatorPosition.bottomRight:
        return Alignment.bottomRight;
      case IndicatorPosition.bottomLeft:
        return Alignment.bottomLeft;
      case IndicatorPosition.centerRight:
        return Alignment.centerRight;
      case IndicatorPosition.centerLeft:
        return Alignment.centerLeft;
    }
  }

  /// This method is use to select the type of indicator from the [SmoothPageIndicator].
  dynamic _getIndicatorType() {
    return ExpandingDotsEffect(
      spacing: widget.indicatorDotSpacing,
      radius: widget.indicatorDotRadius,
      offset: widget.indicatorOffset,
      activeDotColor: widget.indicatorActiveDotColor,
      dotHeight: widget.indicatorDotHeight,
      dotWidth: widget.indicatorDotWidth,
      dotColor: widget.indicatorInActiveDotColor,
      strokeWidth: widget.indicatorStrokeWidth,
      paintStyle: widget.indicatorPaintStyle,
      expansionFactor: widget.indicatorExpansionFactor,
    );
  }
}

/// enum [IndicatorPosition] for selecting the position of page indicator.
enum IndicatorPosition {
  center,
  topCenter,
  topRight,
  topLeft,
  bottomCenter,
  bottomRight,
  bottomLeft,
  centerRight,
  centerLeft,
}
