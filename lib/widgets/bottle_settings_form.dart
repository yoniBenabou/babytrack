import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class BottleSettingsForm extends StatefulWidget {
  const BottleSettingsForm({super.key});

  @override
  State<BottleSettingsForm> createState() => _BottleSettingsFormState();
}

class _BottleSettingsFormState extends State<BottleSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  int _min = 10;
  int _max = 210;
  bool _loading = true;

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
      _loading = false;
    });
  }

  Future<void> _save() async {
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
    await prefs.setInt('bottleMin', minValue);
    await prefs.setInt('bottleMax', maxValue);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Paramètres enregistrés.'),
    ));
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Pour éviter que la barre de navigation ou le clavier masque le contenu
    return SafeArea(
      child: SingleChildScrollView(
        padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text('Paramètres biberon', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Row(
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
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Annuler'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
