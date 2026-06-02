import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import '../services/gps_service.dart';

class CalendarWeatherScreen extends StatefulWidget {
  final Map<String, dynamic>? weatherData;
  const CalendarWeatherScreen({super.key, this.weatherData});

  @override
  State<CalendarWeatherScreen> createState() => _CalendarWeatherScreenState();
}

class _CalendarWeatherScreenState extends State<CalendarWeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final GPSService _gpsService = GPSService();
  Map<String, dynamic>? _currentWeatherData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentWeatherData = widget.weatherData;
  }

  Future<void> _fetchNearbyWeatherData() async {
    setState(() => _isLoading = true);
    try {
      final pos = await _gpsService.getPosition();
      final data = await _weatherService.getWeatherByLocation(pos.latitude, pos.longitude);
      setState(() {
        _currentWeatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching nearby weather: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    String locationName = _currentWeatherData?["location"]?["name"] ?? "Unknown Location";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Weather Calendar", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: "Fetch Nearby Weather",
            onPressed: _isLoading ? null : _fetchNearbyWeatherData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _currentWeatherData == null || _currentWeatherData!["forecast"] == null
              ? const Center(child: Text("No forecast data available. Tap the location icon."))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            currentMonth,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "Showing data for: $locationName",
                                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: (_currentWeatherData!["forecast"]["forecastday"] as List).length,
                        itemBuilder: (context, index) {
                          var day = _currentWeatherData!["forecast"]["forecastday"][index];
                          DateTime date = DateTime.parse(day['date']);
                          String dayName = DateFormat('EEEE').format(date);
                          String dayNum = DateFormat('dd').format(date);

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayName,
                                    style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    dayNum,
                                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  const SizedBox(height: 10),
                                  Image.network(
                                    "https:${day['day']['condition']['icon']}",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${day['day']['avgtemp_c'].round()}°C",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                  Text(
                                    day['day']['condition']['text'],
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
