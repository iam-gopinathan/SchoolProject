// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
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
//   bool _isAnimationCompleted = false;
//   bool _isNewsLoaded = false;
//   List<NewsArticle> _newsArticles = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadNews();
//   }

//   /// Fetch news data from API
//   Future<void> _loadNews() async {
//     try {
//       _newsArticles = await fetchNews();
//       _isNewsLoaded = true;
//       _navigateToLogin();
//     } catch (error) {
//       print('Error loading news: $error');
//     }
//   }

//   /// Navigate to login screen only when both conditions are met
//   void _navigateToLogin() {
//     if (_isAnimationCompleted && _isNewsLoaded) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Loginpage(newsArticles: _newsArticles),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.appBackgroundPrimaryColor,
//       body: Center(
//         child: Lottie.asset(
//           'assets/images/Msms_splashvideo.json',
//           fit: BoxFit.cover,
//           frameRate: FrameRate.max,
//           onLoaded: (composition) {
//             Future.delayed(composition.duration, () {
//               setState(() {
//                 _isAnimationCompleted = true;
//               });
//               _navigateToLogin();
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_1/screens/loginscreen.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
import 'package:flutter_application_1/services/Login_Api/loginpage_news.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  List<NewsArticle> _newsArticles = [];

  var image = 'assets/images/splashscreen_image.png';

  bool _showText = false;

  @override
  void initState() {
    _loadNews();

    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showText = true;
      });
    });
    image;

    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Loginpage(
                    newsArticles: _newsArticles,
                  )));
    });
  }

  //
  Future<void> _loadNews() async {
    try {
      _newsArticles = await fetchNews();
    } catch (error) {
      print('Error loading news: $error');
    }
  }

  //
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
          Center(
            child: Image.asset(
              image,
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
