import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'home_menu_page.dart';
import 'my_page.dart';
import '../widgets/custom_app_bar_title.dart';

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
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    if (widget.isRenting) {
      rentalStatus = "대여";
      returnDueDate = DateTime.now().add(const Duration(days: 3));
    } else {
      rentalStatus = "반납";
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
              Navigator.pop(context); // 팝업 닫기
              Navigator.pop(context, returnData ?? returnFlag); // QR 페이지 닫기 + 데이터 전달
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
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
                  if (_scanned) return;
                  _scanned = true;
                  controller?.pauseCamera();

                  final code = scanData.code ?? "";
                  print("✅ 스캔된 QR: $code");

                  if (widget.isRenting && code.startsWith("rental:")) {
                    final returnDate = returnDueDate?.toLocal().toString().split(' ')[0] ?? '';
                    final message = "${widget.itemName} 대여가 완료되었습니다.\n반납 예정일은 $returnDate입니다.";

                    _showNotificationDialog(
                      "대여 완료",
                      message,
                      returnData: {
                        'name': widget.itemName,
                        'dueDate': returnDate,
                      },
                    );
                  } else if (!widget.isRenting && code.startsWith ("return:")) {
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
