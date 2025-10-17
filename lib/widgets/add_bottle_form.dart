import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cyclic_hour_minute_picker.dart';

class AddBottleForm extends StatefulWidget {
  const AddBottleForm({super.key});

  @override
  State<AddBottleForm> createState() => _AddBottleFormState();
}

class _AddBottleFormState extends State<AddBottleForm> {
  double _amount = 150;
  int _selectedHour = TimeOfDay.now().hour;
  int _selectedMinute = (TimeOfDay.now().minute ~/ 5) * 5;
  DateTime _selectedDate = DateTime.now();
  int _minLimit = 10;
  int _maxLimit = 210;

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

  @override
  void initState() {
    super.initState();
    _loadLimits();
  }

  Future<void> _loadLimits() async {
    final prefs = await SharedPreferences.getInstance();
    final min = prefs.getInt('bottleMin') ?? 10;
    final max = prefs.getInt('bottleMax') ?? 210;
    // ensure sensible defaults
    final safeMin = min > 0 ? min : 10;
    final safeMax = max > safeMin ? max : (safeMin + 200);
    setState(() {
      _minLimit = safeMin;
      _maxLimit = safeMax;
      // clamp _amount into range
      if (_amount < _minLimit) _amount = _minLimit.toDouble();
      if (_amount > _maxLimit) _amount = _maxLimit.toDouble();
    });
  }

  void _submit() {
    //ajout dans la base de données
    CollectionReference biberonRef = FirebaseFirestore.instance.collection(
        'Biberon');
    // clamp quantity and convert to int
    final qty = _amount.clamp(_minLimit.toDouble(), _maxLimit.toDouble()).toInt();
    biberonRef.add({
      'quantity': qty,
      'date': DateTime(_selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedHour,
          _selectedMinute),
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
              Text('Choisis la quantité bue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('${_amount.toInt()} ml', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
              Slider(
                value: _amount,
                min: _minLimit.toDouble(),
                max: _maxLimit.toDouble(),
                divisions: ((_maxLimit - _minLimit) ~/ 10).clamp(1, 1000),
                label: '${_amount.toInt()} ml',
                onChanged: (value) {
                  setState(() {
                    // round to nearest 10
                    final rounded = (value / 10).round() * 10;
                    // clamp between min and max
                    final clamped = rounded.clamp(_minLimit, _maxLimit).toDouble();
                    _amount = clamped;
                  });
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Date : ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: Icon(Icons.calendar_today, color: Colors.blue),
                    label: Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/'
                      '${_selectedDate.month.toString().padLeft(2, '0')}/'
                      '${_selectedDate.year}',
                      style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
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
                  backgroundColor: Colors.blue,
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
