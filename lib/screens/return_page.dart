import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/shared_preferences_util.dart';

class ReturnPage extends StatefulWidget {
  final List<Map<String, dynamic>> myRentals;
  final void Function(int)? onReturnComplete;

  const ReturnPage({
    super.key,
    required this.myRentals,
    this.onReturnComplete,
  });

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  int? selectedIndex;
  bool isScanning = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  List<Map<String, dynamic>> get filteredRentals {
    return widget.myRentals
        .asMap()
        .entries
        .where((entry) {
      final rental = entry.value;
      return rental['returnedAt'] == null ||
          rental['statusMessage'] == '대여 중입니다.';
    })
        .map((e) => e.value)
        .toList();
  }

  Future<void> _startReturnProcess(int index) async {
    setState(() {
      selectedIndex = index;
      isScanning = true;
    });
  }

  Future<void> _onQRScanned(String qrData) async {
    if (!qrData.startsWith('return:')) {
      _showDialog('QR 오류', '올바른 반납 QR코드가 아닙니다.');
      return;
    }

    if (selectedIndex == null) return;

    final selectedItem = filteredRentals[selectedIndex!];
    final userId = await SharedPreferencesUtil.getUserId();
    final role = await SharedPreferencesUtil.getUserRole();
    final now = DateTime.now();

    final body = jsonEncode({
      "itemId": selectedItem['itemId'],
      "item": selectedItem['item'],
      "userId": userId,
      "role": role,
      "returnedAt": now.toIso8601String(),
      "statusMessage": "반납 완료"
    });

    final url = Uri.parse('http://172.30.1.12:8080/rental/return');
    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      if (widget.onReturnComplete != null) {
        widget.onReturnComplete!(selectedIndex!);
      }
      _showDialog('반납 완료', '물품이 반납되었습니다.');
    } else {
      _showDialog('오류', '서버 오류가 발생했습니다.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          )
        ],
      ),
    ).then((_) => Navigator.pop(context));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('반납 목록')),
      body: isScanning
          ? QRView(
        key: qrKey,
        onQRViewCreated: (ctrl) {
          controller = ctrl;
          ctrl.scannedDataStream.listen((scanData) async {
            if (!isScanning) return;
            setState(() => isScanning = false);
            controller?.pauseCamera();
            await _onQRScanned(scanData.code ?? '');
          });
        },
      )
          : filteredRentals.isEmpty
          ? const Center(child: Text("반납할 물품이 없습니다."))
          : ListView.builder(
        itemCount: filteredRentals.length,
        itemBuilder: (context, index) {
          final item = filteredRentals[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['item'] ?? item['name'] ?? '이름 없음',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("반납일: ${item['dueDate'] ?? ''}", style: const TextStyle(color: Colors.grey)),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _startReturnProcess(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("반납하기"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
