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
                    BottlesCard(
                      bottles: bottles,
                      cardFontSize: cardFontSize,
                      cardIconSize: cardIconSize,
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
