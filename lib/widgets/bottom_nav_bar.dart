import 'package:flutter/material.dart';
import '../screens/rental_status_page.dart';
import '../screens/mission_home.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      // 미션스쿨로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MissionHome()),
      );
    } else {
      // 한남렌탈 탭 눌렀을 때
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RentalStatusPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag), // 렌탈 아이콘
          label: '한남렌탈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school), // 학교 아이콘
          label: '미션스쿨',
        ),
      ],
      backgroundColor: Colors.white,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
    );
  }
}