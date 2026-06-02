import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/auth/login_screen.dart';
import 'package:weather_app/theme/light_theme.dart';
import 'package:weather_app/theme/dark_theme.dart';
import 'package:weather_app/services/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDjmO6zxj8xiwsNWvC_KHhBoAOMy4uEDe4",
      appId: "1:899758575595:android:93f97c193360390e1013ae",
      messagingSenderId: "899758575595",
      projectId: "weather-f0e68",
      databaseURL: "https://weather-f0e68-default-rtdb.firebaseio.com",
      storageBucket: "weather-f0e68.firebasestorage.app",
    ),
  );

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'weather_alerts',
        channelName: 'Weather Alerts',
        channelDescription: 'Notifications for rain, storms and updates',
        defaultColor: const Color(0xFF9D50BB),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
      ),
    ],
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "Weather App",
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
