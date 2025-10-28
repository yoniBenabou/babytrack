import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import '../utils/size_config.dart';
import 'add_vitamin_form.dart';
import 'edit_vitamin_form.dart';

/// Carte combinée affichant Fer et Vitamine D côte à côte dans une seule card,
/// séparées par un trait, sans date/heure. La couleur indique si la vitamine a été donnée aujourd'hui.
class VitaminsCard extends StatelessWidget {
  final DocumentSnapshot? ironDoc;
  final DocumentSnapshot? vdDoc;
  final bool ironIsToday;
  final bool vdIsToday;
  final double cardFontSize;
  final double cardIconSize;
  final String selectedBebe;

  const VitaminsCard({
    this.ironDoc,
    this.vdDoc,
    required this.ironIsToday,
    required this.vdIsToday,
    required this.cardFontSize,
    required this.cardIconSize,
    required this.selectedBebe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
     // Utiliser vert si donné aujourd'hui, rouge sinon (au lieu du gris)
     // On garde des teintes claires pour ne pas casser la lisibilité du texte.
    final Color ironBg = ironIsToday ? Colors.green.shade100 : Colors.red.shade100;
    final Color vdBg = vdIsToday ? Colors.green.shade100 : Colors.red.shade100;

    String _fullDateTimeFromDoc(DocumentSnapshot? d) {
      if (d == null) return 'Aucun';
      final data = d.data() as Map<String, dynamic>?;
      if (data == null) return 'Aucun';
      final ts = data['date'];
      if (ts == null) return 'Aucun';
      final DateTime dt = ts is DateTime ? ts : (ts as dynamic).toDate();
      return DateFormat('dd/MM/yyyy à HH:mm').format(dt);
    }

    final String ironFull = _fullDateTimeFromDoc(ironDoc);
    final String vdFull = _fullDateTimeFromDoc(vdDoc);

    Widget _buildLine({required String label, required String datetime, required Color bgColor, required VoidCallback onTap}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          color: bgColor.withAlpha((0.08 * 255).round()),
          child: Row(
            children: [
              // petite pastille colorée
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                datetime,
                style: TextStyle(fontSize: cardFontSize * 0.85, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône medicament + Titre + bouton + sur la même ligne
            Row(
              children: [
                // pastille avec emoji médicament
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    radius: (cardFontSize * 1.1),
                    child: Text('💊', style: TextStyle(fontSize: cardFontSize * 0.9)),
                  ),
                ),
                Expanded(
                  child: Text('Dernière vitamine', style: TextStyle(fontSize: cardFontSize * 1.05, fontWeight: FontWeight.bold)),
                ),
                CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: cardIconSize * 0.9),
                    tooltip: 'Ajouter',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => AddVitaminForm(selectedBebe: selectedBebe),
                      );
                    },
                  ),
                ),
              ],
            ),
           // const SizedBox(height: 1),
            // Vitamine D en premier ligne
            _buildLine(
              label: 'Vitamine D',
              datetime: vdFull,
              bgColor: vdBg,
              onTap: () {
                if (vdDoc != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => EditVitaminForm(vitaminDoc: vdDoc!, selectedBebe: selectedBebe),
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => AddVitaminForm(initialType: 'vitamin_d', selectedBebe: selectedBebe),
                  );
                }
              },
            ),
           // const SizedBox(height: 6),
            // Fer en seconde ligne
            _buildLine(
              label: 'Fer',
              datetime: ironFull,
              bgColor: ironBg,
              onTap: () {
                if (ironDoc != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => EditVitaminForm(vitaminDoc: ironDoc!, selectedBebe: selectedBebe),
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => AddVitaminForm(initialType: 'iron', selectedBebe: selectedBebe),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
