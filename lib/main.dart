import 'package:c_box/screens/home_menu_page.dart';
import 'package:c_box/screens/login_page.dart';
import 'package:c_box/screens/signup_page.dart';
import 'package:c_box/screens/splash.dart';
import 'package:flutter/material.dart';
import 'screens/mission_home.dart';


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
      routes: {
        '/': (context) => SplashPage(),
      //  '/login': (context) => const LoginPage(),
      //  '/signup': (context) => const SignupPage(),
        '/home_menu_page': (context) => const HomeMenuPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
