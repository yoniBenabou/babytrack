import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class EditPoopForm extends StatefulWidget {
  final DocumentSnapshot poopDoc;
  final String selectedBebe;
  const EditPoopForm({required this.poopDoc, required this.selectedBebe, super.key});

  @override
  State<EditPoopForm> createState() => _EditPoopFormState();
}

class _EditPoopFormState extends State<EditPoopForm> {
  late int _selectedHour;
  late int _selectedMinute;
  late DateTime _selectedDate;
  String? _notes;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // Lire le timestamp 'at' (peut être Timestamp ou DateTime)
    final rawAt = widget.poopDoc.get('at');
    final atDate = rawAt is Timestamp ? rawAt.toDate() : (rawAt as DateTime);
    _selectedDate = DateTime(atDate.year, atDate.month, atDate.day);
    _selectedHour = atDate.hour;
    _selectedMinute = atDate.minute;
    _notes = widget.poopDoc.get('notes') as String?;
    _notesController = TextEditingController(text: _notes ?? '');
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

  // Retourne la référence vers la sous-collection Poops du bébé sélectionné
  CollectionReference get _poopCollectionRef => FirebaseFirestore.instance
      .collection('Babies')
      .doc(widget.selectedBebe)
      .collection('Poops');

  void _submit() async {
    try {
      final atValue = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedHour, _selectedMinute);
      // Prendre la valeur source existante si présente, sinon 'manual'
      final existing = widget.poopDoc.data() as Map<String, dynamic>?;
      final sourceValue = existing != null && existing['source'] != null ? existing['source'] as String : 'manual';

      await _poopCollectionRef.doc(widget.poopDoc.id).update({
        'at': atValue,
        'notes': _notesController.text,
        'source': sourceValue,
      });
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')));
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
              Text('Modifier la selle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
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
              SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Notes (optionnel)',
                    border: OutlineInputBorder(),
                    hintText: 'Ajouter des remarques...',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                  style: TextStyle(fontSize: 14),
                  maxLines: 1,
                  controller: _notesController,
                ),
              ),
              SizedBox(height: 24),
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
                child: const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              TextButton.icon(
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('Supprimer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  try {
                    await _poopCollectionRef.doc(widget.poopDoc.id).delete();
                    if (!mounted) return;
                    Navigator.of(context).pop(true);
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression : $e')));
                  }
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
