// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
// import 'dart:async';
// import 'package:flutter_application_1/screens/loginscreen.dart';
// import 'package:flutter_application_1/services/Login_Api/loginpage_news.dart';
// import 'package:flutter_application_1/utils/theme.dart';
// import 'package:lottie/lottie.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   late final Widget lottieAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _loadNewsAndNavigate();
//     //
//     lottieAnimation = Lottie.asset(
//       'assets/images/Msms_splashvideo.json',
//       fit: BoxFit.cover,
//       frameRate: FrameRate.max,
//     );
//   }

//   //api integration code for login news..
//   Future<void> _loadNewsAndNavigate() async {
//     try {
//       List<NewsArticle> newsArticles = await fetchNews();

//       Timer(Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Loginpage(newsArticles: newsArticles),
//           ),
//         );
//       });
//     } catch (error) {
//       print('Error loading news: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.appBackgroundPrimaryColor,
//       body: Center(
//         child: lottieAnimation,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
import 'package:flutter_application_1/screens/loginscreen.dart';
import 'package:flutter_application_1/services/Login_Api/loginpage_news.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _isAnimationCompleted = false;
  bool _isNewsLoaded = false;
  List<NewsArticle> _newsArticles = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  /// Fetch news data from API
  Future<void> _loadNews() async {
    try {
      _newsArticles = await fetchNews();
      _isNewsLoaded = true;
      _navigateToLogin();
    } catch (error) {
      print('Error loading news: $error');
    }
  }

  /// Navigate to login screen only when both conditions are met
  void _navigateToLogin() {
    if (_isAnimationCompleted && _isNewsLoaded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Loginpage(newsArticles: _newsArticles),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundPrimaryColor,
      body: Center(
        child: Lottie.asset(
          'assets/images/Msms_splashvideo.json',
          fit: BoxFit.cover,
          frameRate: FrameRate.max,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              setState(() {
                _isAnimationCompleted = true;
              });
              _navigateToLogin();
            });
          },
        ),
      ),
    );
  }
}
