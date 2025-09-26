import 'package:flutter/material.dart';
import 'pages/main_screen.dart';

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
