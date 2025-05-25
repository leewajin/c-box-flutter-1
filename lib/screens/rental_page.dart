import 'package:flutter/material.dart';
import '../screens/rental_qr_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<String> filteredItems = (rentalItems[selectedCollege] ?? [])
        .where((item) => item.contains(searchText))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("대여")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📚 단과대 리스트
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
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '물품 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => searchText = value);
              },
            ),
          ),

          // ➕ 물품 등록
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: '새 물품 이름 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final newItem = _itemController.text.trim();
                    if (newItem.isNotEmpty) {
                      setState(() {
                        rentalItems[selectedCollege] ??= [];
                        rentalItems[selectedCollege]!.add(newItem);
                        _itemController.clear();
                      });
                    }
                  },
                  child: const Text("등록"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🎒 물품 목록
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: Text(item),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QRScanPage(
                              itemName: item,
                              isRenting: true,
                            ),
                          ),
                        );
                      },
                      child: const Text('대여하기'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}