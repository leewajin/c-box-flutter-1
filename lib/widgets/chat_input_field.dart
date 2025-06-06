import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend;

  const ChatInputField({
    Key? key,
    this.controller,
    this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend?.call(),
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: onSend ?? () {},
          ),
        ],
      ),
    );
  }
}
