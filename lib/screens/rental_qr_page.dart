import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/shared_preferences_util.dart';
import 'home_menu_page.dart';
import 'my_page.dart';

class QRScanPage extends StatefulWidget {
  final String itemName;
  final bool isRenting; // true: 대여, false: 반납


  const QRScanPage({
    super.key,
    required this.itemName,
    required this.isRenting,
  });

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _scanned = false;

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) async {
      if (_scanned) return;
      _scanned = true;
      controller?.pauseCamera();

      final qrData = scanData.code;
      if (qrData == null || !qrData.startsWith('rental:')) {
        _showDialog('QR 오류', '잘못된 QR 코드입니다.', null); // ✅ null 추가!
        return;
      }

      final parts = qrData.split(':');
      if (parts.length != 3) {
        _showDialog('QR 오류', 'QR 코드 형식이 잘못되었습니다.', null); // ✅ null 추가!
        return;
      }

      if (qrData.startsWith('rental:')){
        _showDialog('QR','대여 완료되었습니다.',null);
      }

      final itemId = int.tryParse(parts[1]);
      final item = parts[2];

      final userId = await SharedPreferencesUtil.getUserId();
      final role = await SharedPreferencesUtil.getUserRole();

      final now = DateTime.now();
      final due = now.add(const Duration(days: 3));

      final requestBody = {
        "itemId": itemId,
        "item": item,
        "userId": userId,
        "role": role,
        "rentedAt": widget.isRenting ? now.toIso8601String() : null,
        "dueDate": widget.isRenting ? due.toIso8601String() : null,
        "returnedAt": widget.isRenting ? null : now.toIso8601String(),
        "daysLeft": widget.isRenting ? 3 : 0,
        "statusMessage": widget.isRenting ? "대여 중입니다." : "반납 완료"
      };

      final url = Uri.parse('http://172.3.0.58:8080/rental/${widget.isRenting ? 'rent' : 'return'}');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      if (response.statusCode == 200) {
        // ✅ 성공 시 팝업 → 확인 누르면 상위로 pop(itemId 전달)
        _showDialog(
          '성공',
          widget.isRenting ? '대여 완료되었습니다.' : '반납 완료되었습니다.',
              () {
            Navigator.pop(context, itemId); // ✅ 팝업 닫은 후 상위 페이지로 이동
          },
        );
      } else {
        _showDialog('오류', '서버 오류가 발생했습니다.', null); // ✅ 실패 시는 이동 없음
      }
    });
  }

  void _showDialog(String title, String message, VoidCallback? onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ✅ 팝업(AlertDialog) 닫기
              if (onConfirm != null) {
                onConfirm(); // ✅ 팝업 닫은 뒤 실제 이동 처리
              }
            },
            child: const Text('확인'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isRenting ? '대여 QR 스캔' : '반납 QR 스캔')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(widget.isRenting ? '대여할 QR을 스캔하세요' : '반납할 QR을 스캔하세요'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
