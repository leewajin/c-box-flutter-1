import 'package:flutter/material.dart';
import '../screens/rental_page.dart';
import '../screens/return_page.dart';
import '../screens/rental_qr_page.dart'; // QRScanPage import
import '../widgets/custom_app_bar_title.dart';
import 'mission_home.dart';

class RentalStatusPage extends StatefulWidget {
  const RentalStatusPage({super.key});

  @override
  State<RentalStatusPage> createState() => _RentalStatusPageState();
}

class _RentalStatusPageState extends State<RentalStatusPage> {
  List<Map<String, String>> myRentals = []; // 대여중인 물품 리스트

  void _onBottomTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MissionHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "대여 중인 물품",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ 대여 목록 표시
          if (myRentals.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("현재 대여 중인 물품이 없습니다."),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: myRentals.length,
                itemBuilder: (context, index) {
                  final item = myRentals[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.inventory),
                        title: Text(item['name'] ?? ''),
                        subtitle: Text("반납일: ${item['dueDate']}"),
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          // ✅ 대여 / 반납 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RentalPage(),
                      ),
                    );

                    // ✅ QRScanPage에서 Navigator.pop(context, {name, dueDate})로 넘겨주는 경우
                    if (result != null && result is Map<String, String>) {
                      setState(() {
                        myRentals.add(result);
                      });
                    }
                  },
                  child: const Text("대여하러 가기"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReturnPage(
                          myRentals: myRentals,
                          onReturnComplete: (index) {
                            setState(() {
                              myRentals.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text("반납하러 가기"),
                ),
              ],
            ),
          ),
        ],
      ),

      // ✅ 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onBottomTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '한남렌탈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '미션스쿨',
          ),
        ],
      ),
    );
  }
}
