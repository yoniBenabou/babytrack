import 'package:flutter/material.dart';
import 'card_title.dart';

class VitaminCard extends StatelessWidget {
  final String time;
  const VitaminCard({required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const CardTitle("Dernière prise de vitamine"),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(Icons.medication, color: Colors.indigo),
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

