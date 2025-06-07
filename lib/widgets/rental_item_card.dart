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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        // ✅ 카드 스타일 수동 지정 (흰 배경 + 테두리 + 둥근 모서리)
        decoration: BoxDecoration(
          color: Colors.white, // 카드 배경 흰색
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo.shade50, // ✅ 아이콘 배경 (연한 파랑)
            ),
            child: const Icon(
              Icons.inventory, // 기존 아이콘 그대로
              color: Colors.indigo, // ✅ 아이콘 색상 파랑
            ),
          ),
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
              backgroundColor: Colors.indigo, // 버튼 배경 파랑
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // ✅ 둥근 버튼
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                : null, // ❌ 수량 없으면 버튼 비활성화
            child: const Text('대여하기'),
          ),
        ),
      ),
    );
  }
}
