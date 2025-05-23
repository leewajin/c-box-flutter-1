import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("마이페이지")),
      body: const Center(
        child: Text(
          "여기는 마이페이지입니다.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
