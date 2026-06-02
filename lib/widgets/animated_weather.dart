import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedWeather extends StatelessWidget {
  final String condition;

  const AnimatedWeather({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    String anim = "assets/animations/sunny.json";

    final lowerCondition = condition.toLowerCase();
    
    if (lowerCondition.contains("rain") || lowerCondition.contains("drizzle") || lowerCondition.contains("showers")) {
      anim = "assets/animations/rain.json";
    } else if (lowerCondition.contains("cloud") || lowerCondition.contains("mist") || lowerCondition.contains("overcast") || lowerCondition.contains("fog")) {
      anim = "assets/animations/cloudy.json";
    }

    return Center(
      child: Lottie.asset(
        anim,
        height: 180,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.wb_sunny, size: 100, color: Colors.orange);
        },
      ),
    );
  }
}
