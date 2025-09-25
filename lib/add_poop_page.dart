import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPoopPage extends StatefulWidget {
  const AddPoopPage({super.key});

  @override
  State<AddPoopPage> createState() => _AddPoopPageState();
}

class _AddPoopPageState extends State<AddPoopPage> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _submit() async {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    await FirebaseFirestore.instance.collection('poops').add({
      'dateTime': selectedDateTime.toIso8601String(),
    });
    Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un caca')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('Heure du caca :'),
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
