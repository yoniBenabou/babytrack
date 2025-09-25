import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const CardTitle(this.title, {this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

