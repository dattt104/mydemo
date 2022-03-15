// // Flutter
// import 'dart:async';

// import 'package:flutter/material.dart';

// import 'package:business/video/lib.dart';

// // Packages
// import 'package:provider/provider.dart';
// import 'package:business/video/provider/mediaProvider.dart';
// import 'package:business/video/provider/videoPageProvider.dart';
// import 'package:business/video/screens/widget/scroll_behavior.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(Main());
// }

// class Main extends StatefulWidget {
//   @override
//   _MainState createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   @override
//   void didChangeDependencies() async {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<MediaProvider>(
//           create: (context) => MediaProvider(),
//         ),
//         ChangeNotifierProvider<VideoPageProvider>(
//           create: (context) => VideoPageProvider(),
//         ),
//       ],
//       child: Builder(builder: (context) {
//         return MaterialApp(
//           localizationsDelegates: [],
//           debugShowCheckedModeBanner: false,
//           localeResolutionCallback: (locale, supportedLocales) {
//             for (var supportedLocale in supportedLocales) {
//               if (supportedLocale.languageCode == locale?.languageCode &&
//                   supportedLocale.countryCode == locale?.countryCode) {
//                 return supportedLocale;
//               }
//             }
//             return supportedLocales.first;
//           },
//           builder: (context, child) {
//             return ScrollConfiguration(
//               behavior: CustomScrollBehavior(),
//               child: child!,
//             );
//           },
//           title: "MyChannel",
//           initialRoute: 'homeScreen',
//           routes: {
//             'homeScreen': (context) => Material(
//                   child: Lib(),
//                 ),
//           },
//         );
//       }),
//     );
//   }
// }
