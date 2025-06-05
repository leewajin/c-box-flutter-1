import 'package:flutter/material.dart';
import '../screens/rental_qr_page.dart';

class RentalItemCard extends StatelessWidget {
  final String item;
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
        title: Text(item),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
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
              onRented(result);
            }
          },
          child: const Text('대여하기'),
        ),
      ),
    );
  }
}