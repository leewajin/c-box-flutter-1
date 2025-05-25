import 'package:flutter/material.dart';
import '../screens/rental_page.dart';
import '../screens/return_page.dart';
import '../widgets/bottom_nav_bar.dart';

class RentalStatusPage extends StatefulWidget {
  const RentalStatusPage({super.key});

  @override
  State<RentalStatusPage> createState() => _RentalStatusPageState();
}

class _RentalStatusPageState extends State<RentalStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("C:BOX", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("쪽지 알림", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📦 대여 현황 영역
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "대여 중인 물품",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.umbrella),
                title: Text("우산 1개"),
                subtitle: Text("반납일: 2024-05-20"),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ✅ 대여 / 반납 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RentalPage()),
                    );
                  },
                  child: const Text("대여하러 가기"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReturnPage()),
                    );
                  },
                  child: const Text("반납하러 가기"),
                ),
              ],
            ),
          ),
        ],
      ),

      // ✅ 하단 바 다시 추가됨!
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
