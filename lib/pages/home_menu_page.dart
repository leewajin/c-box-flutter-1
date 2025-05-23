import 'package:flutter/material.dart';
import 'rental_status_page.dart';
import '../screens/mission_home.dart';

// import 'mypage.dart'; // 필요 시 마이페이지 화면 파일 생성
// import 'settings_page.dart'; // 필요 시 설정화면 파일 생성

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C:BOX', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuButton(
              context,
              title: '한남렌탈',
              icon: Icons.shopping_bag,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RentalStatusPage()),
                );
              },
            ),
            _buildMenuButton(
              context,
              title: '미션스쿨',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MissionHome()),
                );
              },
            ),
            _buildMenuButton(
              context,
              title: '마이페이지',
              icon: Icons.person,
              onTap: () {
                // TODO: 마이페이지 연결
              },
            ),
            _buildMenuButton(
              context,
              title: '설정',
              icon: Icons.settings,
              onTap: () {
                // TODO: 설정화면 연결
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
