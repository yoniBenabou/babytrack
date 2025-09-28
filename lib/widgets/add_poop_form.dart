import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class AddPoopForm extends StatefulWidget {
  const AddPoopForm({super.key});

  @override
  State<AddPoopForm> createState() => _AddPoopFormState();
}

class _AddPoopFormState extends State<AddPoopForm> {
  int _selectedHour = TimeOfDay.now().hour;
  int _selectedMinute = (TimeOfDay.now().minute ~/ 5) * 5;
  DateTime _selectedDate = DateTime.now();
  String? _notes;

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
    CollectionReference poopRef = FirebaseFirestore.instance.collection('Poop');
    poopRef.add({
      'notes': _notes,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Text('Ajouter une selle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),

          // Sélection de la date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Date : ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: Icon(Icons.calendar_today, color: Colors.brown),
                label: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/'
                  '${_selectedDate.month.toString().padLeft(2, '0')}/'
                  '${_selectedDate.year}',
                  style: TextStyle(fontSize: 18, color: Colors.brown, fontWeight: FontWeight.bold),
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

          // Champ de notes (déplacé en bas et en petit)
          TextField(
            decoration: InputDecoration(
              labelText: 'Notes (optionnel)',
              border: OutlineInputBorder(),
              hintText: 'Ajouter des remarques...',
              labelStyle: TextStyle(fontSize: 14),
            ),
            style: TextStyle(fontSize: 14),
            maxLines: 2,
            onChanged: (value) {
              _notes = value.isEmpty ? null : value;
            },
          ),

          SizedBox(height: 24),

          // Bouton de validation
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              backgroundColor: Colors.brown,
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
    );
  }
}
