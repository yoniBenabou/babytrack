import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cyclic_hour_minute_picker.dart';

class EditBottleForm extends StatefulWidget {
  final String bottleId;
  final int initialQuantity;
  final int initialHour;
  final int initialMinute;

  const EditBottleForm({
    super.key,
    required this.bottleId,
    required this.initialQuantity,
    required this.initialHour,
    required this.initialMinute,
  });

  @override
  State<EditBottleForm> createState() => _EditBottleFormState();
}

class _EditBottleFormState extends State<EditBottleForm> {
  late double _amount;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialQuantity.toDouble();
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
  }

  void _submit() async {
    // Mise à jour dans la base de données
    await FirebaseFirestore.instance.collection('Biberon').doc(widget.bottleId).update({
      'quantity': _amount.toInt(),
      'date': DateTime(DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _selectedHour,
          _selectedMinute),
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
          const Text('🍼', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text('Modifier la quantité bue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('${_amount.toInt()} ml', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
          Slider(
            value: _amount,
            min: 10,
            max: 300,
            divisions: 29,
            label: '${_amount.toInt()} ml',
            onChanged: (value) {
              setState(() {
                _amount = (value/10).round()*10;
              });
            },
          ),
          SizedBox(height: 24),
          Text('Modifier l\'heure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          CyclicHourMinutePicker(
            initialHour: _selectedHour,
            initialMinute: _selectedMinute,
            onHourChanged: (hour) {
              setState(() {
                _selectedHour = hour;
              });
            },
            onMinuteChanged: (minute) {
              setState(() {
                _selectedMinute = minute;
              });
            },
          ),
          SizedBox(height: 8),
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
            child: const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.delete, color: Colors.white),
            label: Text('Supprimer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('Biberon').doc(widget.bottleId).delete();
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
    );
  }
}
