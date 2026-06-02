class RecentCityModel {
  final String city;
  final double temp;
  final String date;

  RecentCityModel({
    required this.city,
    required this.temp,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temp': temp,
      'date': date,
    };
  }

  factory RecentCityModel.fromJson(Map<String, dynamic> json) {
    return RecentCityModel(
      city: json['city'] ?? '',
      temp: (json['temp'] ?? 0).toDouble(),
      date: json['date'] ?? '',
    );
  }
}
