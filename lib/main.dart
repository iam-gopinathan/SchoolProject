import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/Firebase_api.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/splashScreen.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'dart:io';
import 'package:get/get.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initnotification();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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
    final GradeController gradeController = Get.put(GradeController());

    gradeController.fetchGrades();
    return GetMaterialApp(
      //theme code..
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
