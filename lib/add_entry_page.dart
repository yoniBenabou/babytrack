import 'package:flutter/material.dart';
import 'add_bottle_page.dart';
import 'add_poop_page.dart';
import 'add_vitamin_page.dart';

class AddEntryPage extends StatelessWidget {
  const AddEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une entrée'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.local_drink),
              label: const Text('Ajouter un biberon'),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddBottlePage()),
                );
                if (result != null) {
                  Navigator.of(context).pop(result);
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.emoji_emotions),
              label: const Text('Ajouter un caca'),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddPoopPage()),
                );
                if (result != null) {
                  Navigator.of(context).pop(result);
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.medication),
              label: const Text('Ajouter une vitamine'),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddVitaminPage()),
                );
                if (result != null) {
                  Navigator.of(context).pop(result);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
