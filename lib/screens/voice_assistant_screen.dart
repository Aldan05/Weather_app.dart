import 'package:flutter/material.dart';
import '../services/voice_service.dart';
import '../services/weather_service.dart';
import 'home_screen.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  _VoiceAssistantScreenState createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final VoiceService voice = VoiceService();
  final WeatherService weather = WeatherService();

  String heardText = "Tap the mic and say a city name...";
  bool isListening = false;

  void handleVoiceCommand(String text) async {
    setState(() => heardText = text);
    
    String spokenText = text.toLowerCase().trim();

    if (spokenText.contains("open dashboard") || spokenText.contains("go home")) {
      voice.speak("Opening dashboard...");
      Navigator.pop(context);
      return;
    }

    String cityName = spokenText;
    if (spokenText.contains("weather in")) {
      cityName = spokenText.split("weather in").last.trim();
    }

    if (cityName.isEmpty) return;

    voice.speak("Searching weather for $cityName...");
    
    try {
      var data = await weather.fetchWeatherByCity(cityName);
      
      if (data != null) {
        String response =
            "The weather in ${data.city} is ${data.temp.toInt()} degrees Celsius with ${data.main}.";
        
        await voice.speak(response);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Found: ${data.city}")),
          );
          
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              // Now navigating to HomeScreen which includes Calendar and Logout features
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(initialCity: data.city),
                ),
              );
            }
          });
        }
      } else {
        voice.speak("Sorry, I couldn't find any weather data for $cityName.");
      }
    } catch (e) {
      voice.speak("Something went wrong with the search.");
    }
  }

  void startVoice() async {
    if (!isListening) {
      bool ok = await voice.startListening((text) => handleVoiceCommand(text));
      if (ok) {
        setState(() => isListening = true);
      }
    } else {
      await voice.stopListening();
      setState(() => isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("AI Voice Assistant", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Colors.green),
            const SizedBox(height: 30),
            Text(
              heardText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 60),

            GestureDetector(
              onTap: startVoice,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isListening)
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        strokeWidth: 2,
                      ),
                    ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isListening ? Colors.redAccent : Colors.green,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isListening ? "Listening..." : "Tap to Speak",
              style: TextStyle(
                color: isListening ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
