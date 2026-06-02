import 'package:flutter/material.dart';

class VisualizeScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const VisualizeScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    List forecast = weatherData["forecast"]["forecastday"];
    String city = weatherData["location"]["name"];

    // Pre-calculate relative labels for the charts
    final int totalDays = forecast.length;
    List<String> labels = List.generate(totalDays, (index) {
      int daysAgo = totalDays - 1 - index;
      if (daysAgo == 0) return "Today";
      if (daysAgo == 1) return "Yesterday";
      return "$daysAgo d ago";
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Visualizing $city", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("7-Day Temp Trend (Line Chart)", Icons.show_chart),
            _buildLineChart(forecast, labels),
            const SizedBox(height: 30),
            
            _buildSectionTitle("Daily Humidity (Bar Chart)", Icons.water_drop),
            _buildBarChart(forecast, labels),
            const SizedBox(height: 30),
            
            _buildSectionTitle("Wind Speed Profile (Histogram)", Icons.speed),
            _buildHistogram(forecast, labels),
            const SizedBox(height: 30),
            
            _buildSectionTitle("Climate Distribution (Pie Chart)", Icons.pie_chart),
            _buildPieChart(forecast),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // 1. Line Chart (Temperature) - Updated with large labels
  Widget _buildLineChart(List forecast, List<String> labels) {
    List<double> temps = forecast.map((e) => (e["day"]["avgtemp_c"] as num).toDouble()).toList();
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: CustomPaint(
        painter: _LineChartPainter(temps, labels),
      ),
    );
  }

  // 2. Bar Chart (Humidity) - Updated with large labels
  Widget _buildBarChart(List forecast, List<String> labels) {
    double maxVal = 100.0;
    return Container(
      height: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(forecast.length, (i) {
          double val = (forecast[i]["day"]["avghumidity"] as num).toDouble();
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("${val.round()}%", style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
              Container(
                width: 25,
                height: 120 * (val / maxVal),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(height: 8),
              Text(labels[i], style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          );
        }),
      ),
    );
  }

  // 3. Histogram (Wind Speed) - Updated with large labels
  Widget _buildHistogram(List forecast, List<String> labels) {
    List<double> windSpeeds = forecast.map((e) => (e["day"]["maxwind_kph"] as num).toDouble()).toList();
    double maxWind = windSpeeds.reduce((a, b) => a > b ? a : b);
    return Container(
      height: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(windSpeeds.length, (i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 40,
                height: 130 * (windSpeeds[i] / maxWind),
                decoration: const BoxDecoration(color: Colors.orangeAccent),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text("${windSpeeds[i].round()} km/h", style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(labels[i], style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          );
        }),
      ),
    );
  }

  // 4. Pie Chart
  Widget _buildPieChart(List forecast) {
    Map<String, int> counts = {};
    for (var day in forecast) {
      String cond = day["day"]["condition"]["text"];
      counts[cond] = (counts[cond] ?? 0) + 1;
    }
    List<Color> colors = [Colors.green, Colors.blue, Colors.orange, Colors.red, Colors.purple];
    return Row(
      children: [
        SizedBox(height: 160, width: 160, child: CustomPaint(painter: _PieChartPainter(counts.values.toList(), colors))),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: counts.keys.toList().asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: colors[e.key % colors.length]),
                    const SizedBox(width: 8),
                    Text("${e.value}d ${e.key}", style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  _LineChartPainter(this.data, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()..color = Colors.green..strokeWidth = 3..style = PaintingStyle.stroke;
    double chartHeight = size.height - 40;
    double gap = size.width / (data.length - 1);
    double max = data.reduce((a, b) => a > b ? a : b) + 5;
    double min = data.reduce((a, b) => a < b ? a : b) - 5;
    
    Path path = Path();
    for (int i = 0; i < data.length; i++) {
      double x = gap * i;
      double y = chartHeight - ((data[i] - min) / (max - min) * chartHeight * 0.7 + 20);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
      
      // Draw Temp (Large Bold Black)
      _drawText(canvas, "${data[i].round()}°", 14, FontWeight.bold, Offset(x, y - 25));
      
      // Draw Label (Large Bold Black)
      _drawText(canvas, labels[i], 12, FontWeight.bold, Offset(x, chartHeight + 15));
      
      canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.green);
    }
    canvas.drawPath(path, linePaint);
  }

  void _drawText(Canvas canvas, String text, double size, FontWeight weight, Offset offset) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: Colors.black, fontSize: size, fontWeight: weight)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(offset.dx - (tp.width / 2), offset.dy));
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PieChartPainter extends CustomPainter {
  final List<int> values;
  final List<Color> colors;
  _PieChartPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.fold(0, (sum, item) => sum + item);
    double startAngle = 0;
    for (int i = 0; i < values.length; i++) {
      double sweep = (values[i] / total) * 2 * 3.14159;
      canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), startAngle, sweep, true, Paint()..color = colors[i % colors.length]);
      startAngle += sweep;
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
