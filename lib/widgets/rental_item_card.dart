import 'package:flutter/material.dart';
import '../screens/rental_qr_page.dart';
import '../screens/rental_page.dart';

class RentalItemCard extends StatelessWidget {
  final RentalItem item;
  final Function(Map<String, String>) onRented;

  const RentalItemCard({
    super.key,
    required this.item,
    required this.onRented,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.inventory),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.college),
            Text('남은 수량: ${item.quantity}개'),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          onPressed: item.quantity > 0
              ? () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QRScanPage(
                  itemName: item.name,
                  isRenting: true,
                ),
              ),
            );

            if (result != null && result is Map<String, String>) {
              onRented(result);
            }
          }
              : null,  // 수량 없으면 버튼 비활성화
          child: const Text('대여하기'),
        ),
      ),
    );
  }
}