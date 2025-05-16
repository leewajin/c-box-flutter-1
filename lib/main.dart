import 'package:flutter/material.dart';
import 'pages/home_menu_page.dart'; // ← 경로에 맞게 조정

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C:Box',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Pretendard',
      ),
      home: const HomeMenuPage(), // ← 여기로 연결
      debugShowCheckedModeBanner: false,
    );
  }
}

