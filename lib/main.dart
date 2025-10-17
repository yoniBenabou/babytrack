import 'package:flutter/material.dart';
import 'pages/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/welcome_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lire le flag de première ouverture depuis SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seenWelcome') ?? false;

  runApp(BabyTrackApp(showWelcome: !seenWelcome));
}

class BabyTrackApp extends StatelessWidget {
  final bool showWelcome;
  const BabyTrackApp({super.key, required this.showWelcome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyTrack',
      // Si c'est la première ouverture, montrer la page Welcome
      home: showWelcome ? const WelcomePage() : const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
