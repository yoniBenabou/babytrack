import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class EditVitaminForm extends StatefulWidget {
  final DocumentSnapshot vitaminDoc;
  final String selectedBebe;
  final String? originalCollection; // 'VitaminD' or 'Iron'
  const EditVitaminForm({required this.vitaminDoc, required this.selectedBebe, this.originalCollection, super.key});

  @override
  State<EditVitaminForm> createState() => _EditVitaminFormState();
}

class _EditVitaminFormState extends State<EditVitaminForm> {
  late int _selectedHour;
  late int _selectedMinute;
  late DateTime _selectedDate;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    // Lire le champ 'at' (Timestamp ou DateTime)
    final dataMap = widget.vitaminDoc.data() as Map<String, dynamic>?;
    final rawAt = dataMap != null ? dataMap['at'] : null;
    DateTime atDate;
    if (rawAt is Timestamp) {
      atDate = rawAt.toDate();
    } else if (rawAt is DateTime) {
      atDate = rawAt;
    } else {
      atDate = DateTime.now();
    }
    _selectedDate = DateTime(atDate.year, atDate.month, atDate.day);
    _selectedHour = atDate.hour;
    _selectedMinute = atDate.minute;

    // Déduire la collection d'origine : priorité à originalCollection s'il est fourni,
    // sinon utiliser le parent de la référence du document.
    final String originCollection = widget.originalCollection ?? widget.vitaminDoc.reference.parent.id;
    if (originCollection.toLowerCase().contains('vitamind')) {
      _selectedType = 'vitamin_d';
    } else if (originCollection.toLowerCase().contains('iron')) {
      _selectedType = 'iron';
    } else {
      // fallback : utiliser le champ 'type' s'il existe, sinon 'vitamin_d'
      _selectedType = dataMap != null && dataMap['type'] != null ? dataMap['type'] as String : 'vitamin_d';
    }
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

  // Retourne la référence vers la collection adéquate selon le type et le bébé
  CollectionReference _collectionRefForType(String type) {
    if (type == 'vitamin_d') {
      return FirebaseFirestore.instance.collection('Babies').doc(widget.selectedBebe).collection('VitaminD');
    }
    return FirebaseFirestore.instance.collection('Babies').doc(widget.selectedBebe).collection('Iron');
  }

  void _submit() async {
    try {
      final atValue = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedHour, _selectedMinute);
      final sourceValue = (widget.vitaminDoc.data() as Map<String, dynamic>?)?['source'] ?? 'manual';

      // Mise à jour simple du document via sa référence (on ne change pas de collection ici)
      await widget.vitaminDoc.reference.update({
        'at': atValue,
        'source': sourceValue,
        'type': _selectedType,
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

              // Type (lecture seule : déterminé par la collection d'origine)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Type : ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(
                    _selectedType == 'vitamin_d' ? 'Vitamine D' : 'Fer',
                    style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
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
                  try {
                    // Supprimer le document via sa référence (sécurisé quel que soit la collection)
                    await widget.vitaminDoc.reference.delete();
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
