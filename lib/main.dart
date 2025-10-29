import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/welcome_page.dart';
import 'pages/main_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async code
  WidgetsFlutterBinding.ensureInitialized();
  // Enable immersive mode to hide system navigation and status bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Read the 'seenWelcome' flag from local storage
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seenWelcome') ?? false;

  // Launch the app, passing whether to show the welcome page or not
  runApp(BabyTrackApp(showWelcome: !seenWelcome));
}

class BabyTrackApp extends StatelessWidget {
  final bool showWelcome;
  const BabyTrackApp({super.key, required this.showWelcome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyTrack',
      // Show WelcomePage if first launch, otherwise show MainScreen
      home: showWelcome ? const WelcomePage() : const MainScreen(),
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}
