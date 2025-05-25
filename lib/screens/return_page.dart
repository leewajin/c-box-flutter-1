import 'package:flutter/material.dart';

class ReturnPage extends StatelessWidget {
  const ReturnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("반납")),
      body: const Center(
        child: Text("반납 페이지는 추후 구현 예정입니다."),
      ),
    );
  }
}