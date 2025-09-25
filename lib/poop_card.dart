import 'package:flutter/material.dart';
import 'card_title.dart';

class PoopCard extends StatelessWidget {
  final String time;
  const PoopCard({required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const CardTitle("Dernier caca"),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.brown.shade100,
                    child: const Icon(Icons.emoji_emotions, color: Colors.brown),
                  ),
                  title: Text("À $time"),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

