import 'package:flutter/material.dart';
import 'package:zelda_countdown/core/theme/app_theme.dart';
import 'package:zelda_countdown/pages/home_page.dart';

void main() {
  runApp(const ZeldaApp());
}

  class ZeldaApp extends StatefulWidget {
  const ZeldaApp({super.key});

  @override
  State<ZeldaApp> createState() => _ZeldaAppState();
}

  class _ZeldaAppState extends State<ZeldaApp> {
  @override
   Widget build(BuildContext context) {
       return MaterialApp(
        title: 'Zelda - Contagem regressiva', 
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: HomePage(),
      );
  }

}