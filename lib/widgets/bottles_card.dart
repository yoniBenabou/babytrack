/*import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class BottlesCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const BottlesCard({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    final double cardSpace = SizeConfig.vertical(context, 0.02);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.text(context, 0.04))),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.text(context, 0.03)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Derniers biberons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
            SizedBox(height: cardSpace * 0.4),
            for (int i = 0; i < items.length; i++) ...[
              ListTile(
                leading: CircleAvatar(child: Text('${items[i]["amount"]}ml', style: TextStyle(fontSize: cardFontSize))),
                title: Text('À ${items[i]["time"]}', style: TextStyle(fontSize: cardFontSize)),
                contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.text(context, 0.01)),
                minLeadingWidth: cardIconSize,
              ),
              if (i != items.length - 1) Divider(height: cardSpace * 0.3, thickness: 1),
            ],
          ],
        ),
      ),
    );
  }
}*/

