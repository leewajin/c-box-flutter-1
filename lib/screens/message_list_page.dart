import 'package:flutter/material.dart';
import '../widgets/message_item.dart';
import 'chat_page.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({super.key});

  // 샘플 데이터
  final List<Map<String, String>> _messages = const [
    {
      'username': '유저1',
      'snippet': '안녕하세요',
      'time': '오전 9:24',
    },
    {
      'username': '유저1',
      'snippet': '쪽지 보냈습니다.',
      'time': '어제',
    },
    {
      'username': '유저1',
      'snippet': '안녕하세요! 내일 오후 3시쯤 가능하실까요?',
      'time': '2024.4.23',
    },
    {
      'username': '유저1',
      'snippet': '2024.4.22',
      'time': '50분 전',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('쪽지 목록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: _messages.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final msg = _messages[index];
          return InkWell(
            onTap: () {
              // 여기다 Navigator.push 스니펫 적용!
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(username: msg['username']!),
                ),
              );
            },
            child: MessageItem(
              username: msg['username']!,
              snippet: msg['snippet']!,
              time: msg['time']!,
            ),
          );
        },
      ),
    );
  }
}