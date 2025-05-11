import 'package:flutter/material.dart';

class CommentCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const CommentCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const Text('댓글 허용'),
      ],
    );
  }
}