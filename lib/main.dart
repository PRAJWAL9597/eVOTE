import 'package:flutter/material.dart';
import 'pages/start_page.dart';
import 'pages/metamask.dart';
import 'pages/home_page.dart'; // make sure this exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eVOTe',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/metamask': (context) => const MetaMaskLoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
