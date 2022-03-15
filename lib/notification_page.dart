import 'package:business/utils/local_notification_util.dart';
import 'package:business/utils/util.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Notification'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 56.0),
              Utils().buildButton(
                label: 'Hiển thị & đăng ký thông báo',
                onPressed: () {
                  LocalNotificationUtil().showAndRepeat();
                },
              ),
              const SizedBox(height: 16.0),
              Utils().buildButton(
                label: 'Huỷ thông báo',
                bgColor: Colors.red,
                onPressed: () async {
                  LocalNotificationUtil().cancelAll();
                },
              ),
            ],
          ),
        ),
      );
}

class PayloadDataPage extends StatelessWidget {
  const PayloadDataPage({
    this.payload,
    Key? key,
  }) : super(key: key);
  final String? payload;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Payload'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 56.0),
              Text('Data: ${payload ?? ''}'),
              const SizedBox(height: 16.0),
              Utils().buildButton(
                label: 'Trở về',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
}
