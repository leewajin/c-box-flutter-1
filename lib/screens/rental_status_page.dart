import 'package:flutter/material.dart';
import '../screens/rental_page.dart';
import '../screens/return_page.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/rental_qr_page.dart';

class RentalStatusPage extends StatefulWidget {
  const RentalStatusPage({super.key});

  @override
  State<RentalStatusPage> createState() => _RentalStatusPageState();
}

class _RentalStatusPageState extends State<RentalStatusPage> {
  List<Map<String, String>> myRentals = []; // 대여중인 물품 리스트

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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "대여 중인 물품",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
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
                    final result = await Navigator.push(
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
