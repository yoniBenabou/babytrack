/*import 'package:flutter/material.dart';

class PastelCard extends StatelessWidget {
  final Color color;
  final String icon;
  final String title;
  final String subtitle;
  final String? extra;
  const PastelCard({required this.color, required this.icon, required this.title, required this.subtitle, this.extra, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32,
              child: Text(icon, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                if (extra != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    extra!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/

