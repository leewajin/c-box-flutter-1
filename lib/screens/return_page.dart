import 'package:flutter/material.dart';
import 'rental_qr_page.dart';

class ReturnPage extends StatelessWidget {
  final List<Map<String, String>> myRentals;
  final Function(int) onReturnComplete;

  const ReturnPage({
    super.key,
    required this.myRentals,
    required this.onReturnComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("반납하기")),
      body: myRentals.isEmpty
          ? const Center(child: Text("반납할 물품이 없습니다."))
          : ListView.builder(
        itemCount: myRentals.length,
        itemBuilder: (context, index) {
          final item = myRentals[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.assignment_return),
              title: Text(item['name'] ?? ''),
              subtitle: Text("반납일: ${item['dueDate']}"),
              trailing: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QRScanPage(
                        itemName: item['name'] ?? '',
                        isRenting: false,
                      ),
                    ),
                  );

                  if (result == true) {
                    onReturnComplete(index); // 부모에서 리스트에서 삭제
                    Navigator.pop(context); // ReturnPage 종료
                  }
                },
                child: const Text("반납하기"),
              ),
            ),
          );
        },
      ),
    );
  }
}
