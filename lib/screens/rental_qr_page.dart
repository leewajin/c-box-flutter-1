import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/shared_preferences_util.dart';
import 'home_menu_page.dart';
import 'my_page.dart';

class QRScanPage extends StatefulWidget {
  final String itemName;
  final int itemId;
  final bool isRenting; // true: 대여, false: 반납

  const QRScanPage({
    super.key,
    required this.itemName,
    required this.itemId,
    required this.isRenting,
  });

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  DateTime? returnDueDate;
  bool _scanned = false;

  Future<void> _sendRentalStatusToBackend({
    required int itemId,
    required String itemName,
    required String userId,
    required String role,
    required DateTime rentedAt,
    required DateTime dueDate,
    DateTime? returnedAt,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/rental'); // 로컬 백엔드 주소
    final body = {
      "itemId": itemId,
      "item": itemName,
      "userId": userId,
      "role": role,
      "rentedAt": rentedAt.toIso8601String(),
      "dueDate": dueDate.toIso8601String(),
      "returnedAt": returnedAt?.toIso8601String(),
    };

    final headers = {"Content-Type": "application/json"};

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode != 200) {
      print("❌ 백엔드 POST 실패: ${response.body}");
    } else {
      print("✅ 백엔드 POST 성공");
    }
  }

  void _showNotificationDialog(String title, String message, {Map<String, String>? returnData, bool returnFlag = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, returnData ?? returnFlag);
            },
            child: const Text("확인"),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("QR 오류"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller?.resumeCamera();
              _scanned = false;
            },
            child: const Text("다시 시도"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("C:BOX"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              String msg = widget.isRenting
                  ? "대여했습니다.\n반납 예정일은 ${returnDueDate?.toLocal().toString().split(' ')[0]}"
                  : "반납했습니다.";
              _showNotificationDialog("알림", msg);
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(widget.itemName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (ctrl) {
                controller = ctrl;
                controller?.scannedDataStream.listen((scanData) async {
                  if (_scanned) return;
                  _scanned = true;
                  controller?.pauseCamera();

                  final code = scanData.code ?? "";
                  final userId = await SharedPreferencesUtil.getUserId();
                  final role = await SharedPreferencesUtil.getUserRole();
                  final now = DateTime.now();

                  if (widget.isRenting && code.startsWith("rental:")) {
                    returnDueDate = now.add(const Duration(days: 3));
                    await _sendRentalStatusToBackend(
                      itemId: widget.itemId,
                      itemName: widget.itemName,
                      userId: userId ?? "unknown",
                      role: role ?? "user",
                      rentedAt: now,
                      dueDate: returnDueDate!,
                    );
                    final returnDateStr = returnDueDate!.toLocal().toString().split(' ')[0];
                    _showNotificationDialog(
                      "대여 완료",
                      "${widget.itemName} 대여가 완료되었습니다.\n반납 예정일은 $returnDateStr입니다.",
                      returnData: {"name": widget.itemName, "dueDate": returnDateStr},
                    );
                  } else if (!widget.isRenting && code.startsWith("return:")) {
                    await _sendRentalStatusToBackend(
                      itemId: widget.itemId,
                      itemName: widget.itemName,
                      userId: userId ?? "unknown",
                      role: role ?? "user",
                      rentedAt: now, // 필요 시 이전 rentedAt과 dueDate를 불러와야 함
                      dueDate: now.add(const Duration(days: 3)),
                      returnedAt: now,
                    );
                    _showNotificationDialog("반납 완료", "${widget.itemName} 반납이 완료되었습니다.", returnFlag: true);
                  } else {
                    _showErrorDialog(
                      widget.isRenting
                          ? "이건 반납용 QR입니다.\n물품에 붙은 대여용 QR을 스캔해주세요."
                          : "이건 대여용 QR입니다.\n반납함에 있는 QR을 스캔해주세요.",
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeMenuPage()),
                        (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
