import 'package:flutter/material.dart';

class AddBottlePage extends StatefulWidget {
  const AddBottlePage({super.key});

  @override
  State<AddBottlePage> createState() => _AddBottlePageState();
}

class _AddBottlePageState extends State<AddBottlePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      Navigator.of(context).pop({
        'amount': int.parse(_amountController.text),
        'dateTime': selectedDateTime.toIso8601String(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un biberon')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantité (ml)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  final n = int.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Entrez un nombre valide (>0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Heure du biberon :'),
                  const SizedBox(width: 16),
                  Text(_selectedTime.format(context)),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: const Text('Changer'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Valider'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
