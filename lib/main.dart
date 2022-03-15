import 'package:business/main_tab.dart';

import 'package:business/video/provider/video_page_provider.dart';
import 'package:business/video/screens/widget/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const _MainPage(title: 'MyApp'),
    );
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VideoPageProvider>(
          create: (context) => VideoPageProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            localizationsDelegates: const [],
            debugShowCheckedModeBanner: false,
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: child!,
              );
            },
            title: 'DEMO',
            home: const Material(
              child: MainTab(),
            ),
          );
        },
      ),
    );
  }
}
