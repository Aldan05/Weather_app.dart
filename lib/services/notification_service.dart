import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // Show instant notification
  static Future<void> showRainAlert(String city) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'weather_alerts',
        title: "🌧 Rain Alert in $city",
        body: "It's going to rain soon! Take an umbrella ☔",
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // Daily morning weather summary
  static Future<void> scheduleDailyWeather() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'weather_alerts',
        title: "☀ Daily Weather Update",
        body: "Check today's weather",
      ),
      schedule: NotificationInterval(
        interval: 86400, // every 24 hours
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        repeats: true,
      ),
    );
  }
}
