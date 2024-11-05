import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';

import 'dart:async';
import 'package:flutter_application_1/screens/loginscreen.dart';
import 'package:flutter_application_1/services/Login_Api/loginpage_news.dart';

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
    _loadNewsAndNavigate();

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/images/splashscreen_image.png'), context);
  }

  //api integration code for login news..
  Future<void> _loadNewsAndNavigate() async {
    try {
      List<NewsArticle> newsArticles = await fetchNews();

      Timer(Duration(seconds: 8), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Loginpage(newsArticles: newsArticles),
          ),
        );
      });
    } catch (error) {
      print('Error loading news: $error');
    }
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
                        color: Colors.black),
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
