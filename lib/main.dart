import 'package:flutter/material.dart';
import 'package:testproject/ui/screens/my_home_page.dart';
import 'package:testproject/ui/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: const MyHomePage(title: 'Стажировка'),
    );
  }
}
