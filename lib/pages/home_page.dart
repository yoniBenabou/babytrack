import 'package:flutter/material.dart';
import '../utils/size_config.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    final double cardSpace = SizeConfig.vertical(context, 0.01);
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
                flex: 4,
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
                                  child: Text('🍼', style: TextStyle(fontSize: cardIconSize*0.9)),
                                ),
                                SizedBox(width: SizeConfig.text(context, 0.025)),
                                Text('Derniers biberons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: cardFontSize)),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.add, color: Colors.white, size: cardIconSize*0.9),
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
                            SizedBox(height: SizeConfig.vertical(context, 0.02)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total journalier :', style: TextStyle(fontSize: cardFontSize, fontWeight: FontWeight.bold)),
                                Text('520 ml', style: TextStyle(fontSize: cardFontSize, color: Colors.blue)),
                              ],
                            )
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
                              child: Text('💩', style: TextStyle(fontSize: cardIconSize*0.9)),
                            ),
                            SizedBox(width: SizeConfig.text(context, 0.03)),
                            Expanded(child: Text('Dernier caca le $poopDate à $poopTime', style: TextStyle(fontSize: cardFontSize))),
                            CircleAvatar(
                              backgroundColor: Colors.brown,
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white, size: cardIconSize*0.9),
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
                              child: Text('💊', style: TextStyle(fontSize: cardIconSize*0.9)),
                            ),
                            SizedBox(width: SizeConfig.text(context, 0.03)),
                            Expanded(child: Text('Dernière vitamine le $vitaminDate à $vitaminTime', style: TextStyle(fontSize: cardFontSize))),
                            CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white, size: cardIconSize*0.9),
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

