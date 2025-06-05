import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/rental_qr_page.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar_title.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  final List<String> colleges = [
    '문과대학', '사범대학', '공과대학', '스마트융합대학', '경상대학',
    '사회과학대학', '생명·나노과학대학', '아트&디자인테크놀로지대학', '린튼글로벌스쿨', '탈메이지 교양·융합대학'
  ];

  String selectedCollege = '문과대학';
  String searchText = '';
  final TextEditingController _itemController = TextEditingController();

  final Map<String, List<String>> rentalItems = {
    '문과대학': ['우산', '보조배터리'],
    '공과대학': ['드라이버', '충전기'],
  };

  Future<void> postRentalToBackend(String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final role = prefs.getString('role');
    final now = DateTime.now();
    final due = now.add(const Duration(days: 3));

    final url = Uri.parse('http://localhost:8080/rental/rent');
    final body = jsonEncode({
      "itemId": null,
      "item": itemName,
      "userId": userId,
      "role": role,
      "rentedAt": now.toIso8601String(),
      "dueDate": due.toIso8601String(),
      "returnedAt": null,
      "daysLeft": 3,
      "statusMessage": "대여 중입니다."
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      print('대여 등록 완료');
    } else {
      print('대여 등록 실패: \${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filteredItems = rentalItems[selectedCollege]
        ?.where((item) => item.contains(searchText))
        .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colleges.length,
              itemBuilder: (context, index) {
                final college = colleges[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(college),
                    selected: selectedCollege == college,
                    onSelected: (_) {
                      setState(() => selectedCollege = college);
                    },
                    selectedColor: Colors.indigo.shade100,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: selectedCollege == college ? Colors.indigo : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '물품 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              onChanged: (value) {
                setState(() => searchText = value);
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.inventory, color: Colors.indigo),
                    title: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QRScanPage(
                              itemName: item,
                              isRenting: true,
                            ),
                          ),
                        );
                        if (result != null && result is Map<String, String>) {
                          await postRentalToBackend(item);
                          Navigator.pop(context, result);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('대여하기'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
