import 'package:flutter/material.dart';
import '../screens/message_list_page.dart';
import '../screens/my_page.dart';
import '../screens/home_menu_page.dart';

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🏠 C:BOX 로고 누르면 홈으로 이동
        InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomeMenuPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
                  (route) => false,
            );
          },
          child: const Text(
            'C:BOX',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),

        const Spacer(),
        //마이페이지 상단 아이콘
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyPage(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),

        // 쪽지 버튼만 남김
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
