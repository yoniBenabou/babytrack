import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBabyPage extends StatefulWidget {
  const AddBabyPage({super.key});

  @override
  State<AddBabyPage> createState() => _AddBabyPageState();
}

class _AddBabyPageState extends State<AddBabyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _saving = false;

  Future<void> _saveBaby() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final docRef = await FirebaseFirestore.instance.collection('Babies').add({
        'firstName': _nameController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Append the new baby id to the user's babyIds list (user doc hardcoded for now)
      final userRef = FirebaseFirestore.instance.collection('Users').doc('329573562');
      await userRef.set({
        'babyIds': FieldValue.arrayUnion([docRef.id])
      }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.of(context).pop(docRef.id);
    } catch (e) {
      debugPrint('Error creating baby: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de la création du bébé')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un bébé')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Prénom du bébé'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Prénom requis' : null,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _saveBaby,
              child: _saving ? const CircularProgressIndicator() : const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}

