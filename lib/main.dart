import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/splashScreen.dart';
import 'package:flutter_application_1/utils/theme.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme code..
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
