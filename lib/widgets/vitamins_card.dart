import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
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

  const VitaminsCard({
    this.ironDoc,
    this.vdDoc,
    required this.ironIsToday,
    required this.vdIsToday,
    required this.cardFontSize,
    required this.cardIconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
     // Utiliser vert si donné aujourd'hui, rouge sinon (au lieu du gris)
     // On garde des teintes claires pour ne pas casser la lisibilité du texte.
    final Color ironBg = ironIsToday ? Colors.green.shade100 : Colors.red.shade100;
    final Color vdBg = vdIsToday ? Colors.green.shade100 : Colors.red.shade100;

    Widget _buildSection({required String label, required Color bgColor, required VoidCallback onTap}) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            color: bgColor,
            child: Center(
              child: Text(
                label,
                style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            // Fer section
            _buildSection(
              label: 'Fer',
              bgColor: ironBg,
              onTap: () {
                if (ironDoc != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => EditVitaminForm(vitaminDoc: ironDoc!),
                  );
                } else {
                  // ouvrir le formulaire d'ajout avec type préselectionné
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => const AddVitaminForm(initialType: 'iron'),
                  );
                }
              },
            ),

            // trait vertical
            Container(width: 1, height: 60, color: Colors.grey.shade400),

            // Vitamine D section
            _buildSection(
              label: 'Vitamine D',
              bgColor: vdBg,
              onTap: () {
                if (vdDoc != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => EditVitaminForm(vitaminDoc: vdDoc!),
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => const AddVitaminForm(initialType: 'vitamin_d'),
                  );
                }
              },
            ),

            // espace avant le +
            SizedBox(width: SizeConfig.text(context, 0.02)),

            // Bouton + unique
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.green.shade400,
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: cardIconSize * 0.9),
                  tooltip: 'Ajouter',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => const AddVitaminForm(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
