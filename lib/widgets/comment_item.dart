import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final String username;
  final String comment;
  final String time;

  const CommentItem({
    super.key,
    required this.username,
    required this.comment,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(comment),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}