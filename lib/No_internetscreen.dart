import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:lottie/lottie.dart';

class NoInternetscreen extends StatefulWidget {
  const NoInternetscreen({super.key});

  @override
  State<NoInternetscreen> createState() => _NoInternetscreenState();
}

class _NoInternetscreenState extends State<NoInternetscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/NoInternet.json',
              fit: BoxFit.cover,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(const ['**'],
                      value: AppTheme.textFieldborderColor),
                ],
              ),
            ),
            //
            Transform.translate(
              offset: Offset(0, -70),
              child: Text(
                "No Internet Connection",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'semibold'),
              ),
            ),
            //
            Transform.translate(
              offset: Offset(0, -60),
              child: Text(
                "Please check your connection and try again.",
                style: TextStyle(
                    fontFamily: 'medium', fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
