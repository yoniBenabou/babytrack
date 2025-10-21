import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'add_vitamin_form.dart';
import 'edit_vitamin_form.dart';

class VitaminCard extends StatelessWidget {
  final String vitaminDate;
  final String vitaminTime;
  final String type; // 'iron' or 'vitamin_d'
  final double cardFontSize;
  final double cardIconSize;
  final DocumentSnapshot? vitaminDoc;
  final bool isToday;
  final String selectedBebe;
  const VitaminCard({
    required this.vitaminDate,
    required this.vitaminTime,
    required this.type,
    required this.cardFontSize,
    required this.cardIconSize,
    this.vitaminDoc,
    required this.isToday,
    required this.selectedBebe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Choix des couleurs et du texte selon le type
    final bool isIron = type == 'iron';
    final Color cardColor = isToday ? Colors.green.shade50 : (isIron ? Colors.red.shade50 : Colors.orange.shade50);
    final Color avatarColor = isToday ? Colors.green.shade300 : (isIron ? Colors.red.shade300 : Colors.orange.shade300);
    final String label = isIron ? 'Dernier Fer le' : 'Dernière Vitamine D le';
    final Widget avatarChild = isIron
        ? Text('Fe', style: TextStyle(fontSize: cardIconSize * 0.7, fontWeight: FontWeight.bold))
        : Text('D', style: TextStyle(fontSize: cardIconSize * 0.9, fontWeight: FontWeight.bold));
    return Card(
      color: cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: avatarColor,
              child: avatarChild,
            ),
            SizedBox(width: SizeConfig.text(context, 0.03)),
            Expanded(
              child: InkWell(
                onTap: vitaminDoc != null
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => EditVitaminForm(vitaminDoc: vitaminDoc!, selectedBebe: selectedBebe),
                        );
                      }
                    : null,
                child: Text(
                  '$label $vitaminDate à $vitaminTime',
                  style: TextStyle(fontSize: cardFontSize),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: avatarColor,
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.green, size: cardIconSize * 0.9),
                tooltip: 'Ajouter une vitamine',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => AddVitaminForm(initialType: type, selectedBebe: selectedBebe),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
