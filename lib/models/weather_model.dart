class WeatherModel {
  final String city;
  final double temp;
  final String main;
  final int humidity;
  final double wind;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.main,
    required this.humidity,
    required this.wind,
  });

  // Factory for OpenWeatherMap (Compatibility)
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["name"] ?? "Unknown",
      temp: (json["main"]?["temp"] ?? 0.0).toDouble(),
      main: (json["weather"] != null && json["weather"].isNotEmpty) 
          ? json["weather"][0]["main"] 
          : "Clear",
      humidity: json["main"]?["humidity"] ?? 0,
      wind: (json["wind"]?["speed"] ?? 0.0).toDouble(),
    );
  }

  // Factory for WeatherAPI.com (Current structure)
  factory WeatherModel.fromWeatherApi(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["location"]?["name"] ?? "Unknown",
      temp: (json["current"]?["temp_c"] ?? 0.0).toDouble(),
      main: json["current"]?["condition"]?["text"] ?? "Clear",
      humidity: json["current"]?["humidity"] ?? 0,
      wind: (json["current"]?["wind_kph"] ?? 0.0).toDouble(),
    );
  }
}
