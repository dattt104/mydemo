import 'package:business/intro_page.dart';
import 'package:business/notification_page.dart';
import 'package:business/utils/local_notification_util.dart';
import 'package:business/utils/review_util.dart';
import 'package:business/utils/util.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  _setupLocalNotification() {
    LocalNotificationUtil().setupLocalNotification(
      onSelectNotification: (String? payload) async {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => PayloadDataPage(
              payload: payload,
            ),
          ),
        );
      },
    );
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        LocalNotificationUtil().requestPermissions();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _setupLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'DEMO',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Utils().buildButton(
              label: 'Đánh giá ứng dụng',
              onPressed: () {
                ReviewUtil().launchReview();
              },
            ),
            Utils().buildButton(
              label: 'Giới thiệu ứng dụng',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroPage(),
                  ),
                );
              },
            ),
            Utils().buildButton(
              label: 'Thông báo',
              onPressed: () {
                _gotoNotificationPage();
              },
            ),
          ],
        ),
      ),
    );
  }

  _gotoNotificationPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const NotificationPage();
        },
      ),
    );
  }
}
