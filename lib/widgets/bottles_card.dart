import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'add_bottle_form.dart';

class BottlesCard extends StatelessWidget {
  final List<Map<String, dynamic>> bottles;
  final double cardFontSize;
  final double cardIconSize;
  const BottlesCard({required this.bottles, required this.cardFontSize, required this.cardIconSize, this.totalJournalier, super.key});
  final int? totalJournalier;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade200,
                  child: Text('🍼', style: TextStyle(fontSize: cardIconSize*0.9)),
                ),
                SizedBox(width: SizeConfig.text(context, 0.025)),
                Text('Derniers biberons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: cardIconSize*0.9),
                      tooltip: 'Ajouter un biberon',
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => const AddBottleForm(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.vertical(context, 0.02)),
            for (int i = 0; i < bottles.length; i++) ...[
              Row(
                children: [
                  Text(_formatDate(bottles[i]["date"]), style: TextStyle(fontSize: cardFontSize)),
                  SizedBox(width: SizeConfig.text(context, 0.04)),
                  Text('${bottles[i]["quantity"] ?? 0} ml', style: TextStyle(fontSize: cardFontSize)),
                ],
              ),
              if (i != bottles.length - 1) const Divider(),
            ],
            SizedBox(height: SizeConfig.vertical(context, 0.02)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total journalier :', style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold)),
                Text('${totalJournalier ?? 0} ml', style: TextStyle(fontSize: cardFontSize, color: Colors.blue)),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    if (date is DateTime) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    try {
      if (date.runtimeType.toString().contains('Timestamp')) {
        final dt = (date as dynamic).toDate();
        return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    return date.toString();
  }
}
