import 'package:flutter/material.dart';

void main() {
  runApp(const BabyTrackApp());
}

class BabyTrackApp extends StatelessWidget {
  const BabyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyTrack',
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Taille relative à l'écran
class SizeConfig {
  static double text(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent;
  }
  static double icon(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent;
  }
  static double vertical(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final double appBarFontSize = SizeConfig.text(context, 0.07); // 7% largeur écran
    final double appBarIconSize = SizeConfig.icon(context, 0.09); // 9% largeur écran
    final double navBarFontSize = SizeConfig.text(context, 0.055); // 5.5% largeur écran
    final double navBarIconSize = SizeConfig.icon(context, 0.09);
    final double navBarHeight = SizeConfig.vertical(context, 0.11); // 11% hauteur écran
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Accueil' : 'Statistiques',
          style: TextStyle(fontSize: appBarFontSize, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        toolbarHeight: navBarHeight,
        leading: Icon(
          _selectedIndex == 0 ? Icons.home : Icons.bar_chart,
          size: appBarIconSize,
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedFontSize: navBarFontSize,
        unselectedFontSize: navBarFontSize,
        iconSize: navBarIconSize,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Statistiques à venir...', style: TextStyle(fontSize: kFontSize)),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055); // 5.5% largeur écran
    final double cardIconSize = SizeConfig.icon(context, 0.07); // 7% largeur écran
    final double cardSpace = SizeConfig.vertical(context, 0.02); // 2% hauteur écran
    final bottles = [
      {'amount': 120, 'time': '08:45', 'date': '25/09/2025'},
      {'amount': 90, 'time': '05:30', 'date': '25/09/2025'},
      {'amount': 110, 'time': '02:10', 'date': '25/09/2025'},
      {'amount': 100, 'time': '23:45', 'date': '24/09/2025'},
      {'amount': 80, 'time': '20:15', 'date': '24/09/2025'},
    ];
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
                flex: 4, // Augmente la place des biberons
                child: ListView(
                  children: [
                    // Carte biberons
                    Card(
                      color: Colors.blue.shade50,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue.shade200,
                                  child: Text('🍼', style: TextStyle(fontSize: cardIconSize)),
                                ),
                                SizedBox(width: SizeConfig.text(context, 0.025)),
                                Text('5 derniers biberons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.add, color: Colors.white, size: cardIconSize),
                                      tooltip: 'Ajouter un biberon',
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.vertical(context, 0.02)),
                            for (int i = 0; i < bottles.length; i++) ...[
                              Row(
                                children: [
                                  Text('${bottles[i]["date"]} ${bottles[i]["time"]}', style: TextStyle(fontSize: cardFontSize)),
                                  SizedBox(width: SizeConfig.text(context, 0.04)),
                                  Text('${bottles[i]["amount"]}ml', style: TextStyle(fontSize: cardFontSize)),
                                ],
                              ),
                              if (i != bottles.length - 1) const Divider(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: cardSpace),
                    // Carte caca
                    Card(
                      color: Colors.brown.shade50,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.brown.shade200,
                              child: Text('💩', style: TextStyle(fontSize: cardIconSize)),
                            ),
                            SizedBox(width: SizeConfig.text(context, 0.03)),
                            Expanded(child: Text('Dernier caca le $poopDate à $poopTime', style: TextStyle(fontSize: cardFontSize))),
                            CircleAvatar(
                              backgroundColor: Colors.brown,
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white, size: cardIconSize),
                                tooltip: 'Ajouter un caca',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: cardSpace),
                    // Carte vitamine
                    Card(
                      color: Colors.indigo.shade50,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.indigo.shade200,
                              child: Text('💊', style: TextStyle(fontSize: cardIconSize)),
                            ),
                            SizedBox(width: SizeConfig.text(context, 0.03)),
                            Expanded(child: Text('Dernière vitamine le $vitaminDate à $vitaminTime', style: TextStyle(fontSize: cardFontSize))),
                            CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white, size: cardIconSize),
                                tooltip: 'Ajouter une vitamine',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
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

// Taille de police uniforme
const double kFontSize = 26;

class BottlesCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const BottlesCard({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    final double cardSpace = SizeConfig.vertical(context, 0.02);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.text(context, 0.04))),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.text(context, 0.03)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('5 derniers biberons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
            SizedBox(height: cardSpace * 0.4),
            for (int i = 0; i < items.length; i++) ...[
              ListTile(
                leading: CircleAvatar(child: Text('${items[i]["amount"]}ml', style: TextStyle(fontSize: cardFontSize))),
                title: Text('À ${items[i]["time"]}', style: TextStyle(fontSize: cardFontSize)),
                contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.text(context, 0.01)),
                minLeadingWidth: cardIconSize,
              ),
              if (i != items.length - 1) Divider(height: cardSpace * 0.3, thickness: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class PoopCard extends StatelessWidget {
  final String time;
  const PoopCard({required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.text(context, 0.04))),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.text(context, 0.03)),
        child: ListTile(
          leading: CircleAvatar(
            radius: cardIconSize * 0.7,
            backgroundColor: Colors.brown.shade100,
            child: Icon(Icons.emoji_emotions, color: Colors.brown, size: cardIconSize),
          ),
          title: Text('Dernier caca à $time', style: TextStyle(fontSize: cardFontSize)),
          contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.text(context, 0.01)),
        ),
      ),
    );
  }
}

class VitaminCard extends StatelessWidget {
  final String time;
  const VitaminCard({required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.text(context, 0.04))),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.text(context, 0.03)),
        child: ListTile(
          leading: CircleAvatar(
            radius: cardIconSize * 0.7,
            backgroundColor: Colors.indigo.shade100,
            child: Icon(Icons.medication, color: Colors.indigo, size: cardIconSize),
          ),
          title: Text('Dernière vitamine à $time', style: TextStyle(fontSize: cardFontSize)),
          contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.text(context, 0.01)),
        ),
      ),
    );
  }
}
