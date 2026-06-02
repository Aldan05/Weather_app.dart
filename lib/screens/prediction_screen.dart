import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PredictionScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const PredictionScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final forecast = weatherData["forecast"]["forecastday"];
    final tomorrow = forecast[1]; // Index 1 is tomorrow
    final today = forecast[0];    // Index 0 is today

    final String condition = tomorrow["day"]["condition"]["text"];
    final double temp = tomorrow["day"]["avgtemp_c"];
    final int rainChance = tomorrow["day"]["daily_chance_of_rain"];
    final double humidityToday = today["day"]["avghumidity"];
    final double humidityTomorrow = tomorrow["day"]["avghumidity"];

    // Basic logic for "Prediction Reason"
    String reasoning = "";
    if (humidityTomorrow > humidityToday) {
      reasoning = "Humidity is rising from ${humidityToday.round()}% to ${humidityTomorrow.round()}%, which increases the likelihood of condensation.";
    } else {
      reasoning = "Humidity is stable, indicating consistent air pressure for tomorrow.";
    }

    if (rainChance > 50) {
      reasoning += " With a ${rainChance}% chance of precipitation, we predict rain is very likely.";
    } else if (temp > 30) {
      reasoning += " High temperatures suggest a clear, sunny day ahead.";
    } else {
      reasoning += " Expect mild weather based on current atmospheric trends.";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Climate Prediction", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Tomorrow's Prediction",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 30),
            
            // Animation based on prediction
            _buildPredictionAnimation(condition),
            
            const SizedBox(height: 20),
            Text(
              "${temp.round()}°C",
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w200, color: Colors.black),
            ),
            Text(
              condition,
              style: const TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 40),
            
            // Prediction Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.green),
                      SizedBox(width: 10),
                      Text("Why this prediction?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    reasoning,
                    style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Chance of Rain indicator
            _buildStatRow("Rain Chance", "$rainChance%", Icons.umbrella, Colors.blue),
            const SizedBox(height: 15),
            _buildStatRow("Predicted Wind", "${tomorrow["day"]["maxwind_kph"]} km/h", Icons.air, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionAnimation(String condition) {
    String anim = "assets/animations/sunny.json";
    if (condition.toLowerCase().contains("rain")) anim = "assets/animations/rain.json";
    if (condition.toLowerCase().contains("cloud")) anim = "assets/animations/cloudy.json";

    return Lottie.asset(
      anim, 
      height: 200,
      errorBuilder: (context, error, stackTrace) {
        // Fallback icon if Lottie file is corrupt
        return const Icon(Icons.wb_sunny, size: 100, color: Colors.orange);
      },
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}
