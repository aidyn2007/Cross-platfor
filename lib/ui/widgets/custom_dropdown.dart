import 'package:flutter/material.dart';

class CustomDropdownMenuItem<T> extends PopupMenuEntry<T> {
  final T value;
  final String text;
  final VoidCallback callback;

  const CustomDropdownMenuItem({
    super.key,
    required this.value,
    required this.text,
    required this.callback,
  });

  @override
  double get height => 48.0;

  @override
  bool represents(T? value) => this.value == value;

  @override
  State<CustomDropdownMenuItem<T>> createState() => _CustomDropdownMenuItemState<T>();
}

class _CustomDropdownMenuItemState<T> extends State<CustomDropdownMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(widget.value),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.callback,
            ),
          ],
        ),
      ),
    );
  }
}
