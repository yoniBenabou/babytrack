import 'package:flutter/material.dart';
// ...existing code...
class AddBottleForm extends StatefulWidget {
  const AddBottleForm({super.key});

  @override
  State<AddBottleForm> createState() => _AddBottleFormState();
}

class _AddBottleFormState extends State<AddBottleForm> {
  double _amount = 120;

  void _submit() {
    print('Quantité: \\${_amount.toInt()} ml');
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
          Text('Choisis la quantité bue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Valider'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
// ...existing code...
