import 'package:flutter/material.dart';

class VoiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoiceButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.mic, color: Colors.white, size: 28),
      ),
    );
  }
}
