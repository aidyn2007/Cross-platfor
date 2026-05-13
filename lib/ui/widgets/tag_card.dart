import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TagCard extends StatelessWidget {
  final String name;
  final bool initiallyChecked;
  final bool evenRow;
  final bool showCheckbox;
  final ValueChanged<bool> onChecked;

  const TagCard({
    super.key,
    required this.name,
    required this.initiallyChecked,
    required this.evenRow,
    required this.showCheckbox,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: evenRow ? Colors.white : smallCardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            if (showCheckbox)
              Checkbox(
                value: initiallyChecked,
                onChanged: (value) => onChecked(value ?? false),
              ),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
