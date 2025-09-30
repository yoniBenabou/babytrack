import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class AddVitaminForm extends StatefulWidget {
  const AddVitaminForm({super.key});

  @override
  State<AddVitaminForm> createState() => _AddVitaminFormState();
}

class _AddVitaminFormState extends State<AddVitaminForm> {
  int _selectedHour = TimeOfDay.now().hour;
  int _selectedMinute = (TimeOfDay.now().minute ~/ 5) * 5;
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onHourChanged(int newHour) {
    // Logique pour changer de jour automatiquement
    if (_selectedHour == 23 && newHour == 0) {
      // Passage de 23h à 00h -> jour suivant
      setState(() {
        _selectedHour = newHour;
        _selectedDate = _selectedDate.add(Duration(days: 1));
      });
    } else if (_selectedHour == 0 && newHour == 23) {
      // Passage de 00h à 23h -> jour précédent
      setState(() {
        _selectedHour = newHour;
        _selectedDate = _selectedDate.subtract(Duration(days: 1));
      });
    } else {
      setState(() {
        _selectedHour = newHour;
      });
    }
  }

  void _submit() {
    // Ajout dans la base de données Firestore
    CollectionReference vitaminRef = FirebaseFirestore.instance.collection('Vitamin');
    vitaminRef.add({
      'date': DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedHour,
        _selectedMinute,
      ),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text('Ajouter une vitamine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),

              // Sélection de la date
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Date : ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: Icon(Icons.calendar_today, color: Colors.green),
                    label: Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/'
                      '${_selectedDate.month.toString().padLeft(2, '0')}/'
                      '${_selectedDate.year}',
                      style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _pickDate,
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Sélection de l'heure
              Text('Sélectionne l\'heure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              CyclicHourMinutePicker(
                initialHour: _selectedHour,
                initialMinute: _selectedMinute,
                onHourChanged: (hour) {
                  _onHourChanged(hour);
                },
                onMinuteChanged: (minute) {
                  setState(() {
                    _selectedMinute = minute;
                  });
                },
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Valider', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
