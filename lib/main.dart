import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/category_provider.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_menu_page.dart';
import 'screens/main_screen.dart'; // 하단바 통합 구조
import 'screens/splash.dart'; // 여기선 SplashPage 사용!

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),

      // SplashPage가 앱 시작 화면
      home: SplashPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home_menu_page': (context) => const HomeMenuPage(),
        '/main': (context) => const MainScreen(), // 필요 시 MainScreen으로도 이동 가능
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
