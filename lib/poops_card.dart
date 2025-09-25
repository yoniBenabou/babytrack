import 'package:flutter/material.dart';
import 'card_title.dart';

class PoopsCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const PoopsCard({required this.items, super.key});

  String _formatDateTime(String isoString) {
    final dt = DateTime.parse(isoString);
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const CardTitle("5 derniers cacas", trailing: Text("Voir tout")),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    Expanded(
                      child: PoopTile(
                        dateTime: _formatDateTime(items[i]["dateTime"]),
                      ),
                    ),
                    if (i != items.length - 1)
                      const Divider(height: 1, thickness: 1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PoopTile extends StatelessWidget {
  final String dateTime;
  const PoopTile({required this.dateTime, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.brown.shade100,
        child: const Icon(Icons.emoji_emotions, color: Colors.brown),
      ),
      title: Text(dateTime),
    );
  }
}
