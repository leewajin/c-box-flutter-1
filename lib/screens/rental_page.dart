import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../widgets/rental_item_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/search_bar.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class RentalItem {
  final String name;
  final String college;
  int quantity;

  RentalItem({
    required this.name,
    required this.college,
    required this.quantity,
  });
}

class _RentalPageState extends State<RentalPage> {
  static const List<String> colleges = [
    '전체', '경상대학', '공과대학', '사회과학대학', '문과대학',
    '생명·나노과학대학', '스마트융합대학', '아트&디자인테크놀로지대학', '사범대학', 'LGS대학'
  ];

  String searchText = '';
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<RentalItem> allItems = [
    RentalItem(name: '우산', college: '문과대학', quantity: 5),
    RentalItem(name: '보조배터리', college: '문과대학', quantity: 2),
    RentalItem(name: '드라이버', college: '공과대학', quantity: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCollege = context.watch<CategoryProvider>().selected;

    List<RentalItem> filteredItems = allItems.where((item) {
      final matchesCollege = selectedCollege == '전체' || item.college == selectedCollege;
      final matchesSearch = item.name.contains(searchText);
      return matchesCollege && matchesSearch;
    }).toList();

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
          const CategoryTabBar(categories: colleges),
          const SizedBox(height: 8),

          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '물품 검색',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim();
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // ➕ 물품 등록
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: '물품 이름',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '수량',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final name = _itemController.text.trim();
                    final qtyText = _quantityController.text.trim();
                    final quantity = int.tryParse(qtyText) ?? 0;

                    if (name.isNotEmpty && quantity > 0 && selectedCollege != '전체') {
                      setState(() {
                        allItems.add(RentalItem(
                          name: name,
                          college: selectedCollege,
                          quantity: quantity,
                        ));
                        _itemController.clear();
                        _quantityController.clear();
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
                return RentalItemCard(
                  item: item,
                  onRented: (result) {
                    Navigator.pop(context, result);
                  },
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
