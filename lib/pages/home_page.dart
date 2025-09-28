import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../widgets/bottles_card.dart';
import '../widgets/poop_card.dart';
import '../widgets/vitamin_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    final double cardSpace = SizeConfig.vertical(context, 0.01);
    final poopTime = '07:55';
    final vitaminTime = '09:00';
    final poopDate = '25/09/2025';
    final vitaminDate = '25/09/2025';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Biberon').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final docs = snapshot.data!.docs;
                        // On trie les biberons du jour par date décroissante
                        final today = DateTime.now();
                        final bottlesToday = docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .where((bottle) {
                            final ts = bottle['date'];
                            if (ts == null) return false;
                            final dt = ts is DateTime ? ts : (ts as dynamic).toDate();
                            return dt.year == today.year && dt.month == today.month && dt.day == today.day;
                          })
                          .toList();
                        bottlesToday.sort((a, b) {
                          final dtA = a['date'] is DateTime ? a['date'] : (a['date'] as dynamic).toDate();
                          final dtB = b['date'] is DateTime ? b['date'] : (b['date'] as dynamic).toDate();
                          return dtB.compareTo(dtA);
                        });
                        // On affiche uniquement les 5 derniers biberons du jour
                        final lastFiveToday = bottlesToday.take(5).toList();
                        // Calcul du total journalier
                        final totalJournalier = bottlesToday.fold<int>(0, (sum, bottle) => sum + ((bottle['quantity'] ?? 0) as int));
                        return Column(
                          children: [
                            BottlesCard(
                              bottles: lastFiveToday.map((bottle) {
                                final dt = bottle['date'] is DateTime ? bottle['date'] : (bottle['date'] as dynamic).toDate();
                                final dateStr = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                                final quantite = bottle['quantity'] ?? 0;
                                return {
                                  ...bottle,
                                  'date': dateStr,
                                  'display': '$dateStr - $quantite ml',
                                };
                              }).toList(),
                              cardFontSize: cardFontSize,
                              cardIconSize: cardIconSize,
                              totalJournalier: totalJournalier,
                            ),

                          ],
                        );
                      },
                    ),
                    SizedBox(height: cardSpace),
                    PoopCard(
                      poopDate: poopDate,
                      poopTime: poopTime,
                      cardFontSize: cardFontSize,
                      cardIconSize: cardIconSize,
                    ),
                    SizedBox(height: cardSpace),
                    VitaminCard(
                      vitaminDate: vitaminDate,
                      vitaminTime: vitaminTime,
                      cardFontSize: cardFontSize,
                      cardIconSize: cardIconSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
