import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class AddVitaminForm extends StatefulWidget {
  final String? initialType; // conservé pour compatibilité, mais par défaut les deux cases sont cochées
  final String selectedBebe;
  const AddVitaminForm({this.initialType, required this.selectedBebe, super.key});

  @override
  State<AddVitaminForm> createState() => _AddVitaminFormState();
}

class _AddVitaminFormState extends State<AddVitaminForm> {
  int _selectedHour = TimeOfDay.now().hour;
  int _selectedMinute = (TimeOfDay.now().minute ~/ 5) * 5;
  DateTime _selectedDate = DateTime.now();
  // Deux cases : Fer et Vitamine D, cochées par défaut
  bool _ironChecked = true;
  bool _vdChecked = true;

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
    // Par défaut : les deux cochées. Si initialType est fourni, ne coche que ce type.
    if (widget.initialType == 'iron') {
      _ironChecked = true;
      _vdChecked = false;
    } else if (widget.initialType == 'vitamin_d') {
      _ironChecked = false;
      _vdChecked = true;
    } else {
      _ironChecked = true;
      _vdChecked = true;
    }
  }

  // Références vers les sous-collections Iron et VitaminD
  CollectionReference _ironRef(String bebe) => FirebaseFirestore.instance.collection('Babies').doc(bebe).collection('Iron');
  CollectionReference _vdRef(String bebe) => FirebaseFirestore.instance.collection('Babies').doc(bebe).collection('VitaminD');

  void _submit() async {
    if (widget.selectedBebe.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucun bébé sélectionné')));
      return;
    }

    try {
      final atValue = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedHour, _selectedMinute);
      if (_ironChecked) {
        await _ironRef(widget.selectedBebe).add({
          'at': atValue,
          'createdAt': Timestamp.now(),
          'source': 'manual',
        });
      }
      if (_vdChecked) {
        await _vdRef(widget.selectedBebe).add({
          'at': atValue,
          'createdAt': Timestamp.now(),
          'source': 'manual',
        });
      }

      // Mise à jour du résumé quotidien dans HistoryLogs/{YYYY-MM-DD}
      final dateKey = '${atValue.year.toString().padLeft(4, '0')}-'
          '${atValue.month.toString().padLeft(2, '0')}-'
          '${atValue.day.toString().padLeft(2, '0')}';
      final historyRef = FirebaseFirestore.instance
          .collection('Babies')
          .doc(widget.selectedBebe)
          .collection('HistoryLogs')
          .doc(dateKey);

      final Map<String, dynamic> updates = {};
      if (_ironChecked) updates['ironCount'] = FieldValue.increment(1);
      if (_vdChecked) updates['vitaminDCount'] = FieldValue.increment(1);
      if (updates.isNotEmpty) {
        await historyRef.set(updates, SetOptions(merge: true));
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout : $e')));
    }
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

              // Cases à cocher pour sélectionner les types à ajouter (par défaut les deux cochées)
              Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Fer'),
                    value: _ironChecked,
                    onChanged: (v) {
                      setState(() {
                        _ironChecked = v ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Vitamine D'),
                    value: _vdChecked,
                    onChanged: (v) {
                      setState(() {
                        _vdChecked = v ?? false;
                      });
                    },
                  ),
                ],
              ),

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
