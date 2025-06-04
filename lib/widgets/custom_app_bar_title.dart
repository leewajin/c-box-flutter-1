import 'package:flutter/material.dart';
import '../screens/message_list_page.dart';

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'C:BOX',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const Spacer(),

        // 알림 버튼 + 배지
        Stack(
          children: [
            const Icon(Icons.notifications_none),
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: const Text(
                  '1',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),

        // 쪽지 버튼
        IconButton(
          icon: const Icon(Icons.mail_outline),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessageListPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}