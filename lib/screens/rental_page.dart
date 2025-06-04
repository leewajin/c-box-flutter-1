import 'package:flutter/material.dart';
import '../screens/rental_qr_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'utils/shared_preferences_util.dart';

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
  bool isAdmin = false;

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemCountController = TextEditingController();

  Map<String, List<Map<String, dynamic>>> rentalItems = {
    '문과대학': [],
    '공과대학': [],
  };

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await SharedPreferencesUtil.getUserRole();
    setState(() {
      isAdmin = role == 'admin';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredItems = (rentalItems[selectedCollege] ?? [])
        .where((item) => item['name'].toString().contains(searchText))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("대여")),
      body: Column(
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
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: Text("${item['name']} (${item['count']}개 남음)"),
                    trailing: ElevatedButton(
                      onPressed: item['count'] > 0
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QRScanPage(
                              itemName: item['name'],
                              itemId: item['id'] ?? 0,
                              isRenting: true,
                            ),
                          ),
                        );
                      }
                          : null,
                      child: const Text('대여하기'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("물품 등록"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(labelText: "물품 이름"),
                  ),
                  TextField(
                    controller: _itemCountController,
                    decoration: const InputDecoration(labelText: "수량"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _itemNameController.clear();
                    _itemCountController.clear();
                  },
                  child: const Text("취소"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = _itemNameController.text.trim();
                    final count = int.tryParse(_itemCountController.text) ?? 0;
                    if (name.isNotEmpty && count > 0) {
                      setState(() {
                        rentalItems[selectedCollege] ??= [];
                        rentalItems[selectedCollege]!.add({
                          'name': name,
                          'count': count,
                          'id': DateTime.now().millisecondsSinceEpoch,
                        });
                        _itemNameController.clear();
                        _itemCountController.clear();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("등록"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
