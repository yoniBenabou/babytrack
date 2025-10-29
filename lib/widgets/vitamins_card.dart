import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import '../utils/size_config.dart';
import 'add_vitamin_form.dart';
import 'edit_vitamin_form.dart';

/// Carte combinée affichant Fer et Vitamine D côte à côte dans une seule card,
/// séparées par un trait, sans date/heure. La couleur indique si la vitamine a été donnée aujourd'hui.
class VitaminsCard extends StatelessWidget {
  final double cardFontSize;
  final double cardIconSize;
  final String selectedBebe;

  const VitaminsCard({
    required this.cardFontSize,
    required this.cardIconSize,
    required this.selectedBebe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // If no baby selected, show a small placeholder card
    if (selectedBebe.isEmpty) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: Colors.blue.shade100, child: Text('💊', style: TextStyle(fontSize: cardFontSize))),
              SizedBox(width: 10),
              Expanded(child: Text('Aucun bébé sélectionné', style: TextStyle(fontSize: cardFontSize))),
              CircleAvatar(backgroundColor: Colors.green.shade400, child: Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      );
    }

    final Stream<QuerySnapshot> vdStream = FirebaseFirestore.instance
        .collection('Babies')
        .doc(selectedBebe)
        .collection('VitaminD')
        .orderBy('at', descending: true)
        .limit(1)
        .snapshots();

    final Stream<QuerySnapshot> ironStream = FirebaseFirestore.instance
        .collection('Babies')
        .doc(selectedBebe)
        .collection('Iron')
        .orderBy('at', descending: true)
        .limit(1)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: vdStream,
      builder: (context, vdSnapshot) {
        DocumentSnapshot? vdDoc;
        bool vdIsToday = false;
        if (vdSnapshot.hasData && vdSnapshot.data!.docs.isNotEmpty) {
          vdDoc = vdSnapshot.data!.docs.first;
          final data = vdDoc.data() as Map<String, dynamic>?;
          if (data != null && data['at'] != null) {
            final dt = data['at'] is DateTime ? data['at'] : (data['at'] as dynamic).toDate();
            final now = DateTime.now();
            vdIsToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
          }
        }

        return StreamBuilder<QuerySnapshot>(
          stream: ironStream,
          builder: (context, ironSnapshot) {
            DocumentSnapshot? ironDoc;
            bool ironIsToday = false;
            if (ironSnapshot.hasData && ironSnapshot.data!.docs.isNotEmpty) {
              ironDoc = ironSnapshot.data!.docs.first;
              final data = ironDoc.data() as Map<String, dynamic>?;
              if (data != null && data['at'] != null) {
                final dt = data['at'] is DateTime ? data['at'] : (data['at'] as dynamic).toDate();
                final now = DateTime.now();
                ironIsToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
              }
            }

            // couleurs basées sur les flags
            final Color ironBg = ironIsToday ? Colors.green.shade100 : Colors.red.shade100;
            final Color vdBg = vdIsToday ? Colors.green.shade100 : Colors.red.shade100;

            String _fullDateTimeFromDoc(DocumentSnapshot? d) {
              if (d == null) return 'Aucun';
              final data = d.data() as Map<String, dynamic>?;
              if (data == null) return 'Aucun';
              final ts = data['at'];
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
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  color: bgColor.withAlpha((0.06 * 255).round()),
                  child: Row(
                    children: [
                      // petite pastille colorée (plus petite)
                      //Container(width: 6, height: 6, decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle)),
                      //SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(fontSize: cardFontSize * 0.9, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        datetime,
                        style: TextStyle(fontSize: cardFontSize * 0.75),
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
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ligne titre + emoji + +
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            radius: (cardFontSize),
                            child: Text('💊', style: TextStyle(fontSize: cardFontSize * 0.85)),
                          ),
                        ),
                        Expanded(
                          child: Text('Dernière vitamine', style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold)),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.green.shade400,
                          radius: (cardIconSize * 0.9),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add, color: Colors.white, size: cardIconSize * 0.8),
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
                    const SizedBox(height: 6),
                    // Vitamine D en premier
                    _buildLine(
                      label: 'Vitamine D',
                      datetime: vdFull,
                      bgColor: vdBg,
                      onTap: () {
                        if (vdDoc != null) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (ctx) => EditVitaminForm(vitaminDoc: vdDoc!, selectedBebe: selectedBebe, originalCollection: vdDoc.reference.parent.id),
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
                    const SizedBox(height: 6),
                    // Fer
                    _buildLine(
                      label: 'Fer',
                      datetime: ironFull,
                      bgColor: ironBg,
                      onTap: () {
                        if (ironDoc != null) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (ctx) => EditVitaminForm(vitaminDoc: ironDoc!, selectedBebe: selectedBebe, originalCollection: ironDoc.reference.parent.id),
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
          },
        );
      },
    );
  }
}
