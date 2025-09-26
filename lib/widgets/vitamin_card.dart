import 'package:flutter/material.dart';
import '../utils/size_config.dart';

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

