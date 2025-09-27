import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'add_bottle_form.dart';

class BottlesCard extends StatelessWidget {
  final List<Map<String, dynamic>> bottles;
  final double cardFontSize;
  final double cardIconSize;
  const BottlesCard({required this.bottles, required this.cardFontSize, required this.cardIconSize, super.key});

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
                  Text('${bottles[i]["date"]} ${bottles[i]["time"]}', style: TextStyle(fontSize: cardFontSize)),
                  SizedBox(width: SizeConfig.text(context, 0.04)),
                  Text('${bottles[i]["amount"]}ml', style: TextStyle(fontSize: cardFontSize)),
                ],
              ),
              if (i != bottles.length - 1) const Divider(),
            ],
            SizedBox(height: SizeConfig.vertical(context, 0.02)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total journalier :', style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold)),
                Text('520 ml', style: TextStyle(fontSize: cardFontSize, color: Colors.blue)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
