import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bottles_card.dart';
import 'poop_card.dart';
import 'vitamin_card.dart';
import 'add_entry_page.dart';
import 'poops_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _addEntry() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEntryPage()),
    );
    if (result != null && result is Map<String, dynamic>) {
      if (result.containsKey('amount') && result.containsKey('dateTime')) {
        await FirebaseFirestore.instance.collection('bottles').add({
          'amount': result['amount'],
          'dateTime': result['dateTime'],
        });
        setState(() {
          // Tri chronologique croissant (plus ancien en haut, plus récent en bas)
          // Tri décroissant : plus récent d'abord
        });
      } else if (result.containsKey('poopTime')) {
        setState(() {
          // Met à jour l'heure de caca
        });
      } else if (result.containsKey('vitaminTime')) {
        setState(() {
          // Met à jour l'heure de vitamine
        });
      }
    }
  }

  // Fonction utilitaire pour parser l'heure HH:mm en minutes depuis minuit
  int _parseTime(String time) {
    final parts = time.split(":");
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BabyTrack"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gap = 12.0;
              final availableH = constraints.maxHeight - gap * 2;
              final hBottles = availableH * 0.60;
              final hPoop = availableH * 0.2;
              final hVitamin = availableH * 0.2;

              return Column(
                children: [
                  SizedBox(
                    height: hBottles,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                        .collection('bottles')
                        .orderBy('dateTime', descending: true)
                        .limit(5)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('Aucun biberon enregistré'));
                        }
                        final items = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                        return BottlesCard(items: items);
                      },
                    ),
                  ),
                  SizedBox(height: gap),
                  SizedBox(
                    height: hPoop,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                        .collection('poops')
                        .orderBy('dateTime', descending: true)
                        .limit(5)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('Aucun caca enregistré'));
                        }
                        final items = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                        return PoopsCard(items: items);
                      },
                    ),
                  ),
                  SizedBox(height: gap),
                  SizedBox(
                    height: hVitamin,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                        .collection('vitamins')
                        .orderBy('dateTime', descending: true)
                        .limit(1)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const VitaminCard(time: '--');
                        }
                        final doc = snapshot.data!.docs.first;
                        final dateTime = doc['dateTime'] as String;
                        final dt = DateTime.parse(dateTime);
                        final formatted = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - "
                          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                        return VitaminCard(time: formatted);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEntry,
        icon: const Icon(Icons.add),
        label: const Text("Ajouter"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Suivi"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ajouter"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historique"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: "Profil"),
        ],
      ),
    );
  }
}
