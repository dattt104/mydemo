import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTap;
  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).cardColor,
      currentIndex: currentIndex,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Product Sans',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Product Sans',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      iconSize: 22,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 8,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).iconTheme.color,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => onItemTap(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.video_call),
          label: 'Video',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Khác',
        ),
      ],
    );
  }
}
