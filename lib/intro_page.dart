import 'package:business/utils/util.dart';
import 'package:business/widget/onboarding/onboarding_animation.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final controller = PageController(
    viewportFraction: 1.0,
    keepPage: true,
  );

  IntroPage({Key? key}) : super(key: key);
  Widget _buildIntroPageModel(
    String imagePath,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> introList = Utils().getIntroList();
    final List<Widget> pages = introList.map((e) {
      return _buildIntroPageModel(e);
    }).toList();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: OnBoardingAnimation(
          pages: pages,
          indicatorInActiveDotColor: Colors.white,
          indicatorActiveDotColor: Colors.orange,
        ),
      ),
    );
  }
}
