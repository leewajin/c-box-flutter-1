import 'package:flutter/material.dart';
import '../screens/post_create_page.dart';  // 글쓰기 페이지 import

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      // 🔥 미션 올리기 버튼 눌렀을 때 PostCreatePage로 이동!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PostCreatePage(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '미션 올리기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '내 프로필',
        ),
      ],
      backgroundColor: Colors.white,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
    );
  }
}