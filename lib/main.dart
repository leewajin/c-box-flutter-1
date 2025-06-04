import 'package:c_box/screens/home_menu_page.dart';
import 'package:c_box/screens/login_page.dart';
import 'package:c_box/screens/signup_page.dart';
import 'package:c_box/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';
import 'screens/mission_home.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(), // 기존 앱 위젯
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // <- AppBar는 이걸 따름!
        ),
      ),
      routes: {
        '/': (context) => SplashPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home_menu_page': (context) => const HomeMenuPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
