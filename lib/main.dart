import 'package:flutter/material.dart';

void main() => runApp(const BabyTrackApp());

class BabyTrackApp extends StatelessWidget {
  const BabyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Données factices (design uniquement)
  List<Map<String, dynamic>> get lastBottles => [
    {"time": "08:45", "amount": 120, "kind": "Lait maternel"},
    {"time": "05:30", "amount": 90, "kind": "Formule"},
    {"time": "02:10", "amount": 110, "kind": "Formule"},
    {"time": "23:45", "amount": 100, "kind": "Lait maternel"},
    {"time": "20:15", "amount": 80, "kind": "Formule"},
  ];

  final Map<String, String> lastPoop = const {
    "time": "07:55",
    "texture": "Mou",
    "color": "Jaune",
    "note": "Normal"
  };

  final Map<String, String> lastVitamin = const {
    "time": "09:00",
    "name": "Vitamine D",
    "dose": "400 IU"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BabyTrack"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Section: 5 derniers biberons
            const _SectionHeader(
              title: "5 derniers biberons",
              actionText: "Voir tout",
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      _BottleTile(
                        amountMl: lastBottles[i]["amount"],
                        kind: lastBottles[i]["kind"],
                        time: lastBottles[i]["time"],
                      ),
                      if (i != 4) const Divider(height: 1),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section: Dernier caca
            const _SectionHeader(title: "Dernier caca"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.brown.shade100,
                  child: const Icon(Icons.emoji_emotions, color: Colors.brown),
                ),
                title: Text("À ${lastPoop["time"]}"),
                subtitle: Text("${lastPoop["texture"]} · ${lastPoop["color"]} · ${lastPoop["note"]}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),

            // Section: Dernière vitamine
            const _SectionHeader(title: "Dernière prise de vitamine"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.indigo.shade100,
                  child: const Icon(Icons.medication, color: Colors.indigo),
                ),
                title: Text("${lastVitamin["name"]} — ${lastVitamin["dose"]}"),
                subtitle: Text("À ${lastVitamin["time"]}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),

      // Bouton flottant (maquette)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Ajouter"),
      ),

      // Barre de navigation (maquette)
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

/* ====== Petits widgets UI ====== */

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  const _SectionHeader({required this.title, this.actionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (actionText != null)
            TextButton(onPressed: () {}, child: Text(actionText!)),
        ],
      ),
    );
  }
}

class _BottleTile extends StatelessWidget {
  final int amountMl;
  final String kind;
  final String time;
  const _BottleTile({required this.amountMl, required this.kind, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blue.shade100,
        child: const Icon(Icons.local_drink, color: Colors.blue),
      ),
      title: Text("$amountMl ml — $kind"),
      subtitle: Text("À $time"),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      onTap: () {},
    );
  }
}
