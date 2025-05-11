import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  /// 외부에서 컨트롤러나 보낼 때 콜백을 붙이고 싶으면 전달하세요.
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
      // 위에 그레이 톤 선 하나
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          // 텍스트 입력
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
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
          // 전송 버튼
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: onSend ?? () {},
          ),
        ],
      ),
    );
  }
}