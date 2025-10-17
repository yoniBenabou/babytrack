import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  int _min = 10;
  int _max = 210;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final min = prefs.getInt('bottleMin') ?? 10;
    final max = prefs.getInt('bottleMax') ?? 210;
    setState(() {
      _min = min;
      _max = max;
      _minController.text = _min.toString();
      _maxController.text = _max.toString();
    });
  }

  Future<void> _onGetStarted(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final minValue = int.tryParse(_minController.text) ?? _min;
    final maxValue = int.tryParse(_maxController.text) ?? _max;

    if (minValue >= maxValue) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('La valeur minimale doit être inférieure à la maximale.'),
      ));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenWelcome', true);
    await prefs.setInt('bottleMin', minValue);
    await prefs.setInt('bottleMax', maxValue);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text('Bienvenue',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                "Bienvenue sur BabyTrack !\nCette application vous aidera à suivre l'alimentation et les soins de votre bébé.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _minController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: 'Quantité minimale (ml)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final parsed = int.tryParse(v ?? '');
                              if (parsed == null) return 'Entier requis';
                              if (parsed <= 0) return 'Doit être > 0';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _maxController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: 'Quantité maximale (ml)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final parsed = int.tryParse(v ?? '');
                              if (parsed == null) return 'Entier requis';
                              if (parsed <= 0) return 'Doit être > 0';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Icon(Icons.baby_changing_station, size: 100, color: Colors.blueAccent),
                  ],
                ),
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onGetStarted(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Commencer', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
