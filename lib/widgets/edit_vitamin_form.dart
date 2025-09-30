import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class EditVitaminForm extends StatefulWidget {
  final DocumentSnapshot vitaminDoc;
  const EditVitaminForm({required this.vitaminDoc, super.key});

  @override
  State<EditVitaminForm> createState() => _EditVitaminFormState();
}

class _EditVitaminFormState extends State<EditVitaminForm> {
  late int _selectedHour;
  late int _selectedMinute;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final date = (widget.vitaminDoc['date'] as Timestamp).toDate();
    _selectedDate = DateTime(date.year, date.month, date.day);
    _selectedHour = date.hour;
    _selectedMinute = date.minute;
  }

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
    if (_selectedHour == 23 && newHour == 0) {
      setState(() {
        _selectedHour = newHour;
        _selectedDate = _selectedDate.add(Duration(days: 1));
      });
    } else if (_selectedHour == 0 && newHour == 23) {
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

  void _submit() async {
    await widget.vitaminDoc.reference.update({
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
              Text('Modifier la vitamine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
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
                child: const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              TextButton.icon(
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('Supprimer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await widget.vitaminDoc.reference.delete();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
