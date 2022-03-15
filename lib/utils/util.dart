import 'package:business/utils/app_images.dart';
import 'package:flutter/material.dart';

class Utils {
  ///
  List<String> getIntroList() => <String>[
        AppImages.intro0,
        AppImages.intro1,
        AppImages.intro2,
        AppImages.intro3,
        AppImages.intro4,
        AppImages.intro5,
        AppImages.intro6,
        AppImages.intro7,
      ];

  ///
  Widget buildButton({
    required String label,
    required Function() onPressed,
    Color? bgColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        elevation: 0.0,
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
