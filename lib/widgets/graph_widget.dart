import 'package:flutter/material.dart';

class GraphWidget extends StatelessWidget {
  final List<dynamic> weekData;

  const GraphWidget({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    // Determine the label for each bar based on its position
    // We reverse the logic to show "3 days ago", "2 days ago", "Yesterday", "Today"
    final int totalDays = weekData.length;
    
    final List<Map<String, dynamic>> data = List.generate(totalDays, (index) {
      final e = weekData[index];
      final temp = e["temp"] ?? e["day"]?["avgtemp_c"] ?? 0.0;
      
      String dayLabel;
      int daysAgo = totalDays - 1 - index;
      
      if (daysAgo == 0) {
        dayLabel = "Today";
      } else if (daysAgo == 1) {
        dayLabel = "Yesterday";
      } else {
        dayLabel = "$daysAgo d ago";
      }

      return {
        "temp": (temp as num).toDouble(),
        "label": dayLabel,
      };
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: CustomPaint(
        size: Size.infinite,
        painter: _HistogramPainter(data),
      ),
    );
  }
}

class _HistogramPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _HistogramPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double chartHeight = size.height - 45; // More space for labels
    final double barWidth = size.width / data.length;
    final double padding = barWidth * 0.15;
    
    final List<double> temps = data.map((e) => e["temp"] as double).toList();
    double maxTemp = temps.reduce((a, b) => a > b ? a : b);
    if (maxTemp < 30) maxTemp = 30;

    final Paint barPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.greenAccent, Colors.green],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));

    for (int i = 0; i < data.length; i++) {
      final double temp = data[i]["temp"];
      final String label = data[i]["label"];
      final double barHeight = (temp / maxTemp) * chartHeight;
      
      // Draw Bar
      final RRect rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * barWidth + padding,
          chartHeight - barHeight,
          barWidth - (padding * 2),
          barHeight,
        ),
        const Radius.circular(6),
      );
      canvas.drawRRect(rect, barPaint);

      // Draw Temp Text (White) - Changed from Black for better visibility on dark BG
      _drawText(canvas, "${temp.round()}°", 14, FontWeight.bold, 
          Offset((i * barWidth) + (barWidth / 2), chartHeight - barHeight - 20));

      // Draw Day Label (White) - Changed from Black for better visibility on dark BG
      _drawText(canvas, label, 12, FontWeight.bold,
          Offset((i * barWidth) + (barWidth / 2), chartHeight + 10));
    }
  }

  void _drawText(Canvas canvas, String text, double size, FontWeight weight, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.white, fontSize: size, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(offset.dx - (textPainter.width / 2), offset.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
