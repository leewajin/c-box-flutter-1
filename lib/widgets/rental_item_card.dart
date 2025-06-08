import 'package:flutter/material.dart';
import '../screens/rental_page.dart'; // RentalItem 클래스 불러오기용

class RentalItemCard extends StatelessWidget {
  final RentalItem item;
  final void Function(int itemId) onRented;

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
        title: Text('${item.name} (${item.college})'),
        subtitle: Text('남은 수량: ${item.quantity}'),
        trailing: ElevatedButton(
          onPressed: item.quantity > 0
              ? () => onRented(item.itemId)
              : null,
          child: const Text('대여하기'),
        ),
      ),
    );
  }
}
