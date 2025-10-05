import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  Future<List<Map<String, dynamic>>> getBiberonDailyTotals() async {
    final now = DateTime.now();
    final List<Map<String, dynamic>> dailyTotals = [];
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final startOfDay = Timestamp.fromDate(day);
      final endOfDay = Timestamp.fromDate(day.add(const Duration(days: 1)));
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Biberon')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();
      int total = 0;
      for (var doc in querySnapshot.docs) {
        // Remplace 'quantite' par le champ réel à additionner
        total += (doc['quantity'] ?? 0) as int;
      }
      dailyTotals.add({
        'date': day,
        'total': total,
      });
    }
    return dailyTotals;
  }

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = 18; // ou adapte avec SizeConfig si tu veux
    final double cardIconSize = 28;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Totaux des 7 derniers jours',
              style: TextStyle(fontSize: kFontSize, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getBiberonDailyTotals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucune donnée pour les 7 derniers jours.'));
                }
                final dailyTotals = snapshot.data!;
                return ListView.builder(
                  itemCount: dailyTotals.length,
                  itemBuilder: (context, index) {
                    final day = dailyTotals[index]['date'] as DateTime;
                    final formattedDate = DateFormat('dd/MM').format(day);
                    final total = dailyTotals[index]['total'];
                    return Card(
                      color: Colors.blue.shade50,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade200,
                              child: Text('🍼', style: TextStyle(fontSize: cardIconSize*0.9)),
                            ),
                            const SizedBox(width: 16),
                            Text(formattedDate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
                            const Spacer(),
                            Text('Total : ', style: TextStyle(fontSize: cardFontSize)),
                            Text('$total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize, color: Colors.blue)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
