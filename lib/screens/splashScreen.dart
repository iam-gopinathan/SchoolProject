import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';

import 'dart:async';
import 'package:flutter_application_1/screens/loginscreen.dart';
import 'package:flutter_application_1/services/Login_Api/loginpage_news.dart';
import 'package:flutter_application_1/utils/theme.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _showText = false;
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    _loadNewsAndNavigate();

    _showImage = true;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showText = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(AppTheme.appLogoImage), context);
    setState(() {
      _showImage = true;
    });
  }

  //api integration code for login news..
  Future<void> _loadNewsAndNavigate() async {
    try {
      List<NewsArticle> newsArticles = await fetchNews();

      Timer(Duration(seconds: 5), () {
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
      backgroundColor: AppTheme.appBackgroundPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              AppTheme.appLogoImage,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          AnimatedOpacity(
            opacity: _showText ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Column(
              children: [
                Center(
                  child: Text(
                    AppTheme.appLogoName,
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
                  AppTheme.appSubtitle.toUpperCase(),
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
