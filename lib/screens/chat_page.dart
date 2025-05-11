import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatPage extends StatelessWidget {
  final String username;

  const ChatPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // 예시 대화 데이터
    final messages = [
      {'text': '내일 오후 3시쯤 가능하실까요?', 'time': '오후 2:30', 'isMe': true},
      {'text': '네, 가능합니다.',                 'time': '오후 2:35', 'isMe': false},
      {'text': '감사합니다!',                   'time': '오후 2:36', 'isMe': true},
      {'text': '감사합니다!',                   'time': '오후 2:36', 'isMe': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 최초 인사 (아바타 + 텍스트)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text(
                  '안녕하세요',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // 대화 리스트
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                return ChatBubble(
                  text: msg['text'] as String,
                  time: msg['time'] as String,
                  isMe: msg['isMe'] as bool,
                );
              },
            ),
          ),

          const ChatInputField(),
        ],
      ),
    );
  }
}