import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_1/screens/loginscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _showText = false;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showImage = true;
      });
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showText = true;
      });
    });

    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/images/splashscreen_image.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 253, 247, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _showImage ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Center(
              child: Image.asset(
                'assets/images/splashscreen_image.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showText ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Morning Star \n Matriculation School',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'semibold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.002,
                ),
                Text(
                  'Where every student thrives'.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'medium',
                    fontSize: 12,
                    color: Color.fromRGBO(17, 101, 109, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
