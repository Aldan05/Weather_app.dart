import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_api_key.dart';
import '../models/weather_model.dart';
import 'notification_service.dart';

class WeatherService {
  final String baseUrl = "https://api.weatherapi.com/v1";

  /// Get Current + 7 Days Forecast (Raw Map)
  Future<Map<String, dynamic>> getWeather(String city) async {
    final url =
        "$baseUrl/forecast.json?key=$weatherApiKey&q=$city&days=7&aqi=no&alerts=yes";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data: ${response.statusCode}");
    }
  }

  /// Get Current Weather as WeatherModel by City Name
  Future<WeatherModel?> fetchWeatherByCity(String city) async {
    final url = "$baseUrl/current.json?key=$weatherApiKey&q=$city";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // Use the safe factory method
      final weather = WeatherModel.fromWeatherApi(data);
      
      if (weather.main.toLowerCase().contains("rain")) {
        NotificationService.showRainAlert(weather.city);
      }
      return weather;
    }
    return null;
  }

  /// Get Current Weather as WeatherModel by GPS
  Future<WeatherModel?> fetchWeatherByGPS(double lat, double lon) async {
    final url = "$baseUrl/current.json?key=$weatherApiKey&q=$lat,$lon";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // Use the safe factory method
      final weather = WeatherModel.fromWeatherApi(data);

      if (weather.main.toLowerCase().contains("rain")) {
        NotificationService.showRainAlert(weather.city);
      }
      return weather;
    }
    return null;
  }

  /// GPS Based Weather (Raw Map for Forecast)
  Future<Map<String, dynamic>> getWeatherByLocation(double lat, double lon) async {
    final url =
        "$baseUrl/forecast.json?key=$weatherApiKey&q=$lat,$lon&days=7&aqi=no&alerts=yes";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("GPS Weather Error: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> get7Days(String city) async {
    return getWeather(city);
  }
}
