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
                        // On récupère tous les biberons et on les trie par date décroissante
                        final allBottles = docs
                          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
                          .toList();
                        allBottles.sort((a, b) {
                          final dtA = a['date'] is DateTime ? a['date'] : (a['date'] as dynamic).toDate();
                          final dtB = b['date'] is DateTime ? b['date'] : (b['date'] as dynamic).toDate();
                          return dtB.compareTo(dtA);
                        });
                        // On affiche les 5 derniers biberons (toutes dates confondues)
                        final lastFiveBottles = allBottles.take(5).toList();

                        // Calcul du total journalier (on garde ce calcul pour aujourd'hui)
                        final today = DateTime.now();
                        final bottlesToday = allBottles.where((bottle) {
                          final ts = bottle['date'];
                          if (ts == null) return false;
                          final dt = ts is DateTime ? ts : (ts as dynamic).toDate();
                          return dt.year == today.year && dt.month == today.month && dt.day == today.day;
                        }).toList();
                        final totalJournalier = bottlesToday.fold<int>(0, (acc, bottle) => acc + ((bottle['quantity'] ?? 0) as int));

                        return Column(
                          children: [
                            BottlesCard(
                              bottles: lastFiveBottles,
                              cardFontSize: cardFontSize,
                              cardIconSize: cardIconSize,
                              totalJournalier: totalJournalier,
                            ),

                          ],
                        );
                      },
                    ),
                    SizedBox(height: cardSpace),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Poop').snapshots(),
                      builder: (context, snapshot) {
                        String poopDate = 'Aucun';
                        String poopTime = '';
                        List<DocumentSnapshot> sortedDocs = [];

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final docs = snapshot.data!.docs;
                          // Trier par date décroissante pour avoir le plus récent
                          sortedDocs = docs.toList();
                          sortedDocs.sort((a, b) {
                            final dataA = a.data() as Map<String, dynamic>;
                            final dataB = b.data() as Map<String, dynamic>;
                            final dateA = dataA['date'] is DateTime ? dataA['date'] : (dataA['date'] as dynamic).toDate();
                            final dateB = dataB['date'] is DateTime ? dataB['date'] : (dataB['date'] as dynamic).toDate();
                            return dateB.compareTo(dateA);
                          });

                          if (sortedDocs.isNotEmpty) {
                            final lastPoopDoc = sortedDocs.first;
                            final lastPoop = lastPoopDoc.data() as Map<String, dynamic>;
                            final date = lastPoop['date'] is DateTime ? lastPoop['date'] : (lastPoop['date'] as dynamic).toDate();
                            poopDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                            poopTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                          }
                        }

                        return PoopCard(
                          poopDate: poopDate,
                          poopTime: poopTime,
                          cardFontSize: cardFontSize,
                          cardIconSize: cardIconSize,
                          poopDoc: sortedDocs.isNotEmpty ? sortedDocs.first : null,
                        );
                      },
                    ),
                    SizedBox(height: cardSpace),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Vitamin').snapshots(),
                      builder: (context, snapshot) {
                        String vitaminDate = 'Aucune';
                        String vitaminTime = '';
                        List<DocumentSnapshot> sortedDocs = [];

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final docs = snapshot.data!.docs;
                          // Trier par date décroissante pour avoir la plus récente
                          sortedDocs = docs.toList();
                          sortedDocs.sort((a, b) {
                            final dataA = a.data() as Map<String, dynamic>;
                            final dataB = b.data() as Map<String, dynamic>;
                            final dateA = dataA['date'] is DateTime ? dataA['date'] : (dataA['date'] as dynamic).toDate();
                            final dateB = dataB['date'] is DateTime ? dataB['date'] : (dataB['date'] as dynamic).toDate();
                            return dateB.compareTo(dateA);
                          });

                          if (sortedDocs.isNotEmpty) {
                            final lastVitaminDoc = sortedDocs.first;
                            final lastVitamin = lastVitaminDoc.data() as Map<String, dynamic>;
                            final date = lastVitamin['date'] is DateTime ? lastVitamin['date'] : (lastVitamin['date'] as dynamic).toDate();
                            vitaminDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                            vitaminTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                          }
                        }

                        return VitaminCard(
                          vitaminDate: vitaminDate,
                          vitaminTime: vitaminTime,
                          cardFontSize: cardFontSize,
                          cardIconSize: cardIconSize,
                          vitaminDoc: sortedDocs.isNotEmpty ? sortedDocs.first : null,
                        );
                      },
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
