import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import 'bottles_last7_page.dart';
import 'bottles_by_day_page.dart' as day_page;

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  /// Retourne les totaux journaliers et la moyenne par biberon sur les 7 derniers jours.
  Future<Map<String, dynamic>> getBiberonStatsLast7Days() async {
    final now = DateTime.now();
    final List<Map<String, dynamic>> dailyTotals = [];
    int totalQuantity = 0;
    int totalCount = 0;

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final startOfDay = Timestamp.fromDate(day);
      final endOfDay = Timestamp.fromDate(day.add(const Duration(days: 1)));
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Biberon')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      int dayTotal = 0;
      for (var doc in querySnapshot.docs) {
        dayTotal += (doc['quantity'] ?? 0) as int;
      }
      dailyTotals.add({'date': day, 'total': dayTotal, 'count': querySnapshot.docs.length});

      totalQuantity += dayTotal;
      totalCount += querySnapshot.docs.length;
    }

    final averagePerBottle = totalCount > 0 ? totalQuantity / totalCount : 0.0;

    return {
      'dailyTotals': dailyTotals.reversed.toList(),
      'averagePerBottle': averagePerBottle,
      'totalQuantity': totalQuantity,
      'totalCount': totalCount,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = 18; // ou adapte avec SizeConfig si tu veux
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Totaux des 7 derniers jours', style: TextStyle(fontSize: kFontSize, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // FutureBuilder qui récupère aussi la moyenne par biberon
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: getBiberonStatsLast7Days(),
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
                final dailyTotals = (data['dailyTotals'] as List<Map<String, dynamic>>);

                return Column(
                  children: [
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Moyenne par biberon (7j)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('${avgPerBottle.toStringAsFixed(1)} ml', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                                  const SizedBox(height: 4),
                                  Text('Total: $totalQty ml • $totalCount biberons', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BottlesLast7Page()));
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('Voir tous les biberons'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Grande carte d'historique sur 7 jours avec mini-barres
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
                            // Affichage simplifié : une ligne par jour (quantité à gauche, date à droite)
                            Column(
                              children: List.generate(dailyTotals.length, (i) {
                                final day = dailyTotals[i]['date'] as DateTime;
                                final int total = dailyTotals[i]['total'] as int;
                                final formattedDate = DateFormat('dd/MM').format(day);
                                // Each row is tappable to show day details
                                final int count = dailyTotals[i]['count'] as int;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => day_page.BottlesByDayPage(day: day)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Text('$total ml • $count biberons', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text(formattedDate, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                                      ],
                                    ),
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
