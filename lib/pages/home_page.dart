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

  @override
  Widget build(BuildContext context) {
    final double cardFontSize = SizeConfig.text(context, 0.055);
    final double cardIconSize = SizeConfig.icon(context, 0.07);
    final double cardSpace = SizeConfig.vertical(context, 0.01);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                flex: 118,
                child: BottlesCard(
                  cardFontSize: cardFontSize,
                  cardIconSize: cardIconSize,
                  selectedBebe: _selectedBaby,
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
                child: VitaminsCard(
                  cardFontSize: cardFontSize,
                  cardIconSize: cardIconSize,
                  selectedBebe: _selectedBaby,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
