import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationUtil {
  ///
  static final LocalNotificationUtil _instance =
      LocalNotificationUtil._internal();
  LocalNotificationUtil._internal();
  factory LocalNotificationUtil() => _instance;

  ///
  final FlutterLocalNotificationsPlugin localNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  ///
  _checkDidLaunchApp({
    required Function(String) onPayload,
  }) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await localNotificationPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      String payload = notificationAppLaunchDetails!.payload ?? '';
      if (payload.trim().isNotEmpty) {
        onPayload(payload);
      }
    }
  }

  ///
  void requestPermissions() {
    localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        )
        .then(
          (value) {},
        );
  }

  ///
  void setupLocalNotification({
    required Function(String?)? onSelectNotification,
  }) async {
    _checkDidLaunchApp(
      onPayload: (String payload) {
        onSelectNotification!(payload);
      },
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) {
        if (kDebugMode) {
          print(
            '=== IOSData ==== ' +
                id.toString() +
                ' > $title > $body > $payload',
          );
        }
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await localNotificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  ///
  void showAndRepeat() async {
    int notificationId = 10;
    String title = 'Thông báo bảo trì hệ thống.';
    String content =
        'Lịch bảo trì hệ thống định kỳ được thực hiện vào lúc 22:00 vào ngày 12/03/2022.';
    String payload = DateTime.now().millisecondsSinceEpoch.toString();

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      contentTitle: title + ' <b>2022</b>',
      summaryText: '',
      htmlFormatBigText: true,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'cId',
      'cName',
      styleInformation: bigTextStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    /// Show Notification Direct
    await localNotificationPlugin.show(
      notificationId,
      title,
      content,
      notificationDetails,
      payload: payload,
    );

    /// Add Repeat Notification
    // DateTime now = DateTime.now();
    await localNotificationPlugin.periodicallyShow(
      notificationId,
      title,
      content,
      RepeatInterval.everyMinute,
      notificationDetails,
      androidAllowWhileIdle: true,
      // calledAt: DateTime(
      //   now.year,
      //   now.month,
      //   now.day,
      //   now.hour,
      //   now.minute + 2, // Test repeat after 2 minutes from now
      // ).millisecondsSinceEpoch,
      payload: payload,
    );
  }

  ///
  void cancelAll() async {
    await localNotificationPlugin.cancelAll();
  }
}
