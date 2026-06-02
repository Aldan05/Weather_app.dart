import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../storage/recent_city_storage.dart';
import '../models/recent_city_model.dart';
import '../widgets/animated_weather.dart';
import '../widgets/weather_card.dart';
import '../widgets/graph_widget.dart';
import 'visualize_screen.dart';
import 'prediction_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String? initialCity;
  final Function(Map<String, dynamic>)? onWeatherDataUpdated;
  const DashboardScreen({super.key, this.initialCity, this.onWeatherDataUpdated});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final weatherService = WeatherService();
  final storage = RecentCityStorage();
  final search = TextEditingController();

  WeatherModel? weather;
  Map<String, dynamic>? fullWeatherData;
  bool loading = true;
  bool isSearching = false; 

  @override
  void initState() {
    super.initState();
    loadInitialState();
  }

  Future<void> loadInitialState() async {
    if (widget.initialCity != null) {
      search.text = widget.initialCity!;
      searchCityWeather();
    } else {
      setState(() {
        weather = null;
        loading = false;
        fullWeatherData = null;
        isSearching = false;
      });
    }
  }

  void _updateLocalData(Map<String, dynamic> data) {
    setState(() {
      fullWeatherData = data;
      weather = WeatherModel.fromWeatherApi(data);
      loading = false;
    });
    if (widget.onWeatherDataUpdated != null) {
      widget.onWeatherDataUpdated!(data);
    }
  }

  Future<void> searchCityWeather() async {
    if (search.text.isEmpty) return;
    
    setState(() {
      loading = true;
      isSearching = true;
    });
    try {
      final data = await weatherService.getWeather(search.text);

      if (data != null && data["location"] != null && data["current"] != null) {
        _updateLocalData(data);

        await storage.saveCity(
          RecentCityModel(city: weather!.city, temp: weather!.temp, date: DateTime.now().toString()),
        );
      } else {
        setState(() {
          weather = null;
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        weather = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.4),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
                  child: Column(
                    children: [
                      // Search Bar Row
                      Row(
                        children: [
                          if (isSearching)
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              onPressed: () {
                                search.clear();
                                setState(() {
                                  isSearching = false;
                                  weather = null;
                                  fullWeatherData = null;
                                });
                              },
                            ),
                          Expanded(
                            child: TextField(
                              controller: search,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Search District or Country",
                                hintStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.15),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search, color: Colors.white, size: 28),
                                  onPressed: searchCityWeather,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onSubmitted: (_) => searchCityWeather(),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // 1. Welcome Home Screen State
                      if (!isSearching && weather == null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            const Icon(Icons.public, size: 140, color: Colors.greenAccent),
                            const SizedBox(height: 30),
                            const Text(
                              "Global 7-Day Climate Insights",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Check any District or Country",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22, color: Colors.greenAccent, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                "Full 7-Day Performance",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                      // 2. City Not Found State
                      if (isSearching && weather == null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            const Icon(Icons.location_off_outlined, size: 120, color: Colors.redAccent),
                            const SizedBox(height: 30),
                            const Text(
                              "District Not Found",
                              style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "It seems the place you searched for doesn't exist in our records.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: Colors.white70),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isSearching = false;
                                  search.clear();
                                });
                              },
                              icon: const Icon(Icons.home_outlined),
                              label: const Text("Go Back Home", style: TextStyle(fontSize: 18)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ],
                        ),

                      // 3. Search Results State
                      if (weather != null)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (fullWeatherData != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VisualizeScreen(weatherData: fullWeatherData!),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.bar_chart, size: 24),
                                  label: const Text("Visualize", style: TextStyle(fontSize: 16)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (fullWeatherData != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PredictionScreen(weatherData: fullWeatherData!),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.auto_awesome, size: 24),
                                  label: const Text("Predict", style: TextStyle(fontSize: 16)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            AnimatedWeather(condition: weather!.main),
                            const SizedBox(height: 10),
                            Text(
                              weather!.city,
                              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              "${weather!.temp.round()}°C",
                              style: const TextStyle(fontSize: 86, fontWeight: FontWeight.w200, color: Colors.white),
                            ),
                            Text(
                              weather!.main,
                              style: const TextStyle(fontSize: 24, color: Colors.white70),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                WeatherCard(title: "Humidity", value: "${weather!.humidity}%", iconPath: "assets/icons/cloudy.png"),
                                WeatherCard(title: "Wind", value: "${weather!.wind} km/h", iconPath: "assets/icons/wind.png"),
                              ],
                            ),
                            const SizedBox(height: 40),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Temperature Trend",
                                style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 220, 
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: GraphWidget(weekData: fullWeatherData?["forecast"]?["forecastday"] ?? []),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
