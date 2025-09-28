import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'add_poop_form.dart';
import 'edit_poop_form.dart';

class PoopCard extends StatelessWidget {
  final String poopDate;
  final String poopTime;
  final double cardFontSize;
  final double cardIconSize;
  final DocumentSnapshot? poopDoc;
  const PoopCard({
    required this.poopDate,
    required this.poopTime,
    required this.cardFontSize,
    required this.cardIconSize,
    this.poopDoc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.brown.shade200,
              child: Text('💩', style: TextStyle(fontSize: cardIconSize*0.9)),
            ),
            SizedBox(width: SizeConfig.text(context, 0.03)),
            Expanded(
              child: InkWell(
                onTap: poopDoc != null
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => EditPoopForm(poopDoc: poopDoc!),
                        );
                      }
                    : null,
                child: Text(
                  'Dernier caca le $poopDate à $poopTime',
                  style: TextStyle(fontSize: cardFontSize),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.brown,
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: cardIconSize*0.9),
                tooltip: 'Ajouter un caca',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => const AddPoopForm(),
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
