import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatelessWidget {
  final String selectedBaby;

  const StatisticsPage({super.key, this.selectedBaby = ''});

  // Récupère les stats HistoryLogs pour les 7 derniers jours pour le bébé sélectionné
  Future<Map<String, dynamic>> _getHistoryLast7Days() async {
    if (selectedBaby.isEmpty) {
      return {
        'days': <Map<String, dynamic>>[],
        'totalQuantity': 0,
        'totalCount': 0,
        'averagePerBottle': 0.0,
      };
    }

    final now = DateTime.now();
    int totalQuantity = 0;
    int totalCount = 0;
    final List<Map<String, dynamic>> days = [];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dateKey = '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      try {
        final doc = await FirebaseFirestore.instance
            .collection('Babies')
            .doc(selectedBaby)
            .collection('HistoryLogs')
            .doc(dateKey)
            .get();

        final data = doc.data();
        final int dayTotalMl = (data != null && data['bottlesTotalQuantity'] != null) ? (data['bottlesTotalQuantity'] as num).toInt() : 0;
        final int dayCount = (data != null && data['bottlesCount'] != null) ? (data['bottlesCount'] as num).toInt() : 0;
        final int poops = (data != null && data['poopsCount'] != null) ? (data['poopsCount'] as num).toInt() : 0;
        final int ironCount = (data != null && data['ironCount'] != null) ? (data['ironCount'] as num).toInt() : 0;
        final int vitaminDCount = (data != null && data['vitaminDCount'] != null) ? (data['vitaminDCount'] as num).toInt() : 0;

        totalQuantity += dayTotalMl;
        totalCount += dayCount;

        days.add({
          'date': day,
          'totalMl': dayTotalMl,
          'bottlesCount': dayCount,
          'poopsCount': poops,
          'iron': ironCount > 0,
          'vitaminD': vitaminDCount > 0,
        });
      } catch (e) {
        // En cas d'erreur, considérer la journée comme vide
        days.add({
          'date': day,
          'totalMl': 0,
          'bottlesCount': 0,
          'poopsCount': 0,
          'iron': false,
          'vitaminD': false,
        });
      }
    }

    final averagePerBottle = totalCount > 0 ? totalQuantity / totalCount : 0.0;

    return {
      'days': days,
      'totalQuantity': totalQuantity,
      'totalCount': totalCount,
      'averagePerBottle': averagePerBottle,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = 18;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _getHistoryLast7Days(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('Aucune donnée pour les 7 derniers jours.'));
                }

                final data = snapshot.data!;
                final double avgPerBottle = (data['averagePerBottle'] as double);
                final int totalQty = (data['totalQuantity'] as int);
                final int totalCount = (data['totalCount'] as int);
                final List<Map<String, dynamic>> days = List<Map<String, dynamic>>.from(data['days'] as List);

                return Column(
                  children: [
                    // Carte résumé (une seule ligne)
                    Card(
                      color: Colors.green.shade50,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.bar_chart, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Moyenne par biberon (7j): ',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '${avgPerBottle.toStringAsFixed(1)} ml',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                                    ),
                                    TextSpan(
                                      text: '  —  Total: $totalQty ml • $totalCount biberons',
                                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Carte historique 7 jours
                    Card(
                      color: Colors.blue.shade50,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Historique - 7 jours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
                            const SizedBox(height: 12),
                            Column(
                              children: List.generate(days.length, (i) {
                                final day = days[i]['date'] as DateTime;
                                final formattedDate = DateFormat('dd/MM').format(day);
                                final int totalMl = days[i]['totalMl'] as int;
                                final int bottlesCount = days[i]['bottlesCount'] as int;
                                final int poopsCount = days[i]['poopsCount'] as int;
                                final bool iron = days[i]['iron'] as bool;
                                final bool vitaminD = days[i]['vitaminD'] as bool;

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Ligne 1: date • ml • nb biberons
                                      Row(
                                        children: [
                                          Text(formattedDate, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          const Spacer(),
                                          Text('$totalMl ml', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 8),
                                          Text('$bottlesCount biberons', style: TextStyle(fontSize: 24, color: Colors.grey.shade800)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      // Ligne 2: nb selles + checks fer/vit D
                                      Row(
                                        children: [
                                          Text('Selles: $poopsCount', style: TextStyle(fontSize: 20, color: Colors.brown.shade700, fontWeight: FontWeight.w600)),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Text('Fer: ',style: TextStyle(fontSize: 20)),
                                              Icon(iron ? Icons.check_circle : Icons.cancel, size: 20, color: iron ? Colors.green : Colors.grey),
                                              const SizedBox(width: 12),
                                              const Text('Vit D: ',style: TextStyle(fontSize: 20)),
                                              Icon(vitaminD ? Icons.check_circle : Icons.cancel, size: 20, color: vitaminD ? Colors.green : Colors.grey),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
