import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _noti = FlutterLocalNotificationsPlugin();
  static final onNotis = BehaviorSubject<String?>();

  static Future showNoti({
    int id = 0,
    String? title,
    String? message,
  }) async =>
      _noti.show(id, title, message, await _notiDetails());

  void func() {}

  static Future showScheduleNoti({
    int id = 0,
    String? title,
    String? message,
    required DateTime scheduleTime,
    String? payload,
  }) async =>
      _noti.zonedSchedule(
        id,
        title,
        message,
        tz.TZDateTime.from(scheduleTime, tz.local),
        await _notiDetails(),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
  static Future _notiDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _noti.initialize(settings,
        onDidReceiveNotificationResponse: (details) {
      onNotis.add(details.payload);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }
}
