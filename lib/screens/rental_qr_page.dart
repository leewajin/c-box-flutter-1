import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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

  String rentalStatus = "";
  DateTime? returnDueDate;
  bool _scanned = false; // 중복 스캔 방지

  @override
  void initState() {
    super.initState();
    if (widget.isRenting) {
      rentalStatus = "대여 완료";
      returnDueDate = DateTime.now().add(const Duration(days: 3));
    } else {
      rentalStatus = "반납 완료";
    }
  }

  void _showNotificationDialog() {
    String message = "";

    if (rentalStatus == "대여 완료") {
      message =
      "대여했습니다.\n반납 예정일은 ${returnDueDate?.toLocal().toString().split(' ')[0]}입니다.";
    } else if (rentalStatus == "반납 완료") {
      message = "반납했습니다.";
    } else {
      message = "대여 상태 없음.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("알림"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
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
            onPressed: _showNotificationDialog,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            widget.itemName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (ctrl) {
                controller = ctrl;
                controller?.scannedDataStream.listen((scanData) {
                  if (!_scanned) {
                    _scanned = true;
                    controller?.pauseCamera();

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("대여 완료"),
                        content: Text("${widget.itemName} 대여가 완료되었습니다."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 팝업 닫기
                              Navigator.pop(context); // QR 페이지 닫기
                            },
                            child: const Text("확인"),
                          )
                        ],
                      ),
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