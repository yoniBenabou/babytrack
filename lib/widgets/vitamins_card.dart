import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    String _shortDateFromDoc(DocumentSnapshot? d) {
      if (d == null) return '';
      final data = d.data() as Map<String, dynamic>?;
      if (data == null) return '';
      final ts = data['date'];
      if (ts == null) return '';
      final DateTime dt = ts is DateTime ? ts : (ts as dynamic).toDate();
      return DateFormat('dd/MM').format(dt);
    }

    final String ironShort = _shortDateFromDoc(ironDoc);
    final String vdShort = _shortDateFromDoc(vdDoc);

    Widget _buildSection({required String label, String? subtitle, required Color bgColor, required VoidCallback onTap}) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            // réduire un peu le padding pour gagner de l'espace
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            color: bgColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: cardFontSize * 0.7, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fer section
              _buildSection(
                label: 'Fer',
                subtitle: ironShort,
                bgColor: ironBg,
                onTap: () {
                  if (ironDoc != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => EditVitaminForm(vitaminDoc: ironDoc!, selectedBebe: selectedBebe),
                    );
                  } else {
                    // ouvrir le formulaire d'ajout avec type préselectionné
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => AddVitaminForm(initialType: 'iron', selectedBebe: selectedBebe),
                    );
                  }
                },
              ),

              // trait vertical
              Container(width: 1, color: Colors.grey.shade400),

              // Vitamine D section
              _buildSection(
                label: 'Vitamine D',
                subtitle: vdShort,
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

              // espace avant le + (0 pour gagner de l'espace horizontal sur petits écrans)
              SizedBox(width: SizeConfig.text(context, 0.015)),

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
                        builder: (ctx) => AddVitaminForm(selectedBebe: selectedBebe),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
