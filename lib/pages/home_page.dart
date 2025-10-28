import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../widgets/bottles_card.dart';
import '../widgets/poop_card.dart';
import '../widgets/vitamins_card.dart';

class HomePage extends StatefulWidget {
  final String selectedBaby;

  const HomePage({super.key, this.selectedBaby = ''});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Use the selected baby passed from parent if provided, otherwise a default
  late String _selectedBaby;

  @override
  void initState() {
    super.initState();
    _selectedBaby = widget.selectedBaby.isNotEmpty ? widget.selectedBaby : 'bébé 1';
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update internal state when parent changes selectedBaby
    if (widget.selectedBaby != oldWidget.selectedBaby && widget.selectedBaby.isNotEmpty) {
      setState(() {
        _selectedBaby = widget.selectedBaby;
      });
    }
  }

  String get _biberonCollection => _selectedBaby != 'bébé 2' ? 'Biberon' : 'Biberon_bebe2';
  String get _vitaminCollection => _selectedBaby == 'bébé 1' ? 'Vitamin' : 'Vitamin_bebe2';

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    final double cardSpace = SizeConfig.vertical(context, 0.01);

    return Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox.expand(
          child: Column(
            children: [

              Expanded(
                flex: 118,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(_biberonCollection).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    final allBottles = docs
                      .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
                      .toList();
                    allBottles.sort((a, b) {
                      final dtA = a['date'] is DateTime ? a['date'] : (a['date'] as dynamic).toDate();
                      final dtB = b['date'] is DateTime ? b['date'] : (b['date'] as dynamic).toDate();
                      return dtB.compareTo(dtA);
                    });
                    final lastFiveBottles = allBottles.take(5).toList();
                    final today = DateTime.now();
                    final bottlesToday = allBottles.where((bottle) {
                      final ts = bottle['date'];
                      if (ts == null) return false;
                      final dt = ts is DateTime ? ts : (ts as dynamic).toDate();
                      return dt.year == today.year && dt.month == today.month && dt.day == today.day;
                    }).toList();
                    final totalJournalier = bottlesToday.fold<int>(0, (acc, bottle) => acc + ((bottle['quantity'] ?? 0) as int));
                    return BottlesCard(
                      bottles: lastFiveBottles,
                      cardFontSize: cardFontSize,
                      cardIconSize: cardIconSize,
                      totalJournalier: totalJournalier,
                      selectedBebe: _selectedBaby,
                    );
                  },
                ),
              ),
              SizedBox(height: cardSpace),
              Expanded(
                flex: 31,
                child: PoopCard(
                  cardFontSize: cardFontSize,
                  cardIconSize: cardIconSize,
                  selectedBebe: _selectedBaby,
                ),
              ),
              SizedBox(height: cardSpace),
              Expanded(
                flex: 56,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(_vitaminCollection).snapshots(),
                  builder: (context, snapshot) {
                    // Préparer les documents par type, compatibilité pour les docs sans 'type' -> 'iron'
                    DocumentSnapshot? ironDoc;
                    bool ironIsToday = false;
                    DocumentSnapshot? vdDoc;
                    bool vdIsToday = false;

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      final docs = snapshot.data!.docs;
                      final ironDocs = docs.where((d) {
                        final data = d.data() as Map<String, dynamic>?;
                        final t = data?['type'] as String?;
                        return t == null || t == 'iron';
                      }).toList();

                      final vdDocs = docs.where((d) {
                        final data = d.data() as Map<String, dynamic>?;
                        final t = data?['type'] as String?;
                        return t == 'vitamin_d';
                      }).toList();

                      DateTime _getDate(DocumentSnapshot d) {
                        final data = d.data() as Map<String, dynamic>;
                        final ts = data['date'];
                        return ts is DateTime ? ts : (ts as dynamic).toDate();
                      }

                      if (ironDocs.isNotEmpty) {
                        ironDocs.sort((a, b) => _getDate(b).compareTo(_getDate(a)));
                        ironDoc = ironDocs.first;
                        final dt = _getDate(ironDoc);
                        final now = DateTime.now();
                        ironIsToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
                      }

                      if (vdDocs.isNotEmpty) {
                        vdDocs.sort((a, b) => _getDate(b).compareTo(_getDate(a)));
                        vdDoc = vdDocs.first;
                        final dt = _getDate(vdDoc);
                        final now = DateTime.now();
                        vdIsToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
                      }
                    }

                    return VitaminsCard(
                      ironDoc: ironDoc,
                      vdDoc: vdDoc,
                      ironIsToday: ironIsToday,
                      vdIsToday: vdIsToday,
                      cardFontSize: cardFontSize,
                      cardIconSize: cardIconSize,
                      selectedBebe: _selectedBaby,
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
