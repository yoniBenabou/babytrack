import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'add_vitamin_form.dart';

class VitaminCard extends StatelessWidget {
  final String vitaminDate;
  final String vitaminTime;
  final double cardFontSize;
  final double cardIconSize;
  const VitaminCard({required this.vitaminDate, required this.vitaminTime, required this.cardFontSize, required this.cardIconSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.shade200,
              child: Text('💊', style: TextStyle(fontSize: cardIconSize*0.9)),
            ),
            SizedBox(width: SizeConfig.text(context, 0.03)),
            Expanded(child: Text('Dernière vitamine le $vitaminDate à $vitaminTime', style: TextStyle(fontSize: cardFontSize))),
            CircleAvatar(
              backgroundColor: Colors.indigo,
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: cardIconSize*0.9),
                tooltip: 'Ajouter une vitamine',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => const AddVitaminForm(),
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
