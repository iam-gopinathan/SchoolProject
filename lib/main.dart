import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/AttendencePage/IrregularAttendencies.dart';
import 'package:flutter_application_1/screens/Dashboard.dart';
import 'package:flutter_application_1/screens/splashScreen.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(new MyApp());
}

//http crertification code...

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // Allow all certificates (for testing purposes only)
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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
