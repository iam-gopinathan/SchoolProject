import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';

import 'package:flutter_application_1/screens/Dashboard.dart';
import 'package:flutter_application_1/screens/Parent_communication_Page.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_Name.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Loginpage extends StatefulWidget {
  final List<NewsArticle> newsArticles;
  const Loginpage({super.key, required this.newsArticles});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoginEnabled = false;
  String? _usernameErrorMessage;
  String? _passwordErrorMessage;

// //login function....
//   bool _isLoading = false;
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       String username = _usernamecontroller.text;
//       String password = _passwordcontroller.text;
//       print('Attempting to login with Username: $username');

//       try {
//         final response = await _authService.login(username, password);
//         print('Full API response: $response');

//         String message = response['message'];

//         setState(() {
//           _usernameErrorMessage = null;
//           _passwordErrorMessage = null;
//         });

//         _isLoading = true;

//         if (response['success'] == true) {
//           String rollNumber = response['rollNumber'];
//           String userType = response['userType'];

//           final dashboardData = await fetchDashboardData(rollNumber, userType);

//           setState(() {
//             _isLoading = false;
//           });

//           if (dashboardData != null) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Dashboard(
//                   username: dashboardData.userDetails.username,
//                   userType: dashboardData.userDetails.usertype,
//                   imagePath: dashboardData.userDetails.filepath,
//                   newsArticles: widget.newsArticles,
//                 ),
//               ),
//             );
//           } else {
//             _usernameErrorMessage =
//                 'Failed to load dashboard data. Please try again.';
//             setState(() {});
//           }
//         } else {
//           _isLoading = false;
//           if (message == "Invalid Username") {
//             _usernameErrorMessage = 'Please enter a valid username.';
//           } else if (message == "Invalid Password") {
//             _passwordErrorMessage = 'Please enter a valid password.';
//           } else {
//             _usernameErrorMessage = 'Invalid username or password.';
//           }
//           setState(() {});
//         }
//       } catch (e) {
//         print('Error during login: $e');
//         setState(() {
//           _usernameErrorMessage =
//               'An unexpected error occurred. Please try again.';
//           _passwordErrorMessage = null;
//         });
//       }
//     } else {
//       print('Form validation failed');
//     }
//   }
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernamecontroller.text;
      String password = _passwordcontroller.text;
      print('Attempting to login with Username: $username');

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _authService.login(username, password);
        print('Full API response: $response');

        String message = response['message'];

        setState(() {
          _usernameErrorMessage = null;
          _passwordErrorMessage = null;
        });

        _isLoading = true;

        if (response['success'] == true) {
          String rollNumber = response['rollNumber'];
          String userType = response['userType'];

          final dashboardData = await fetchDashboardData(rollNumber, userType);

          setState(() {
            _isLoading = false;
          });

          if (dashboardData != null) {
            if (userType == "student") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentCommunicationPage(
                    username: dashboardData.userDetails.username,
                    userType: dashboardData.userDetails.usertype,
                    imagePath: dashboardData.userDetails.filepath,
                    newsArticles: widget.newsArticles,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(
                    username: dashboardData.userDetails.username,
                    userType: dashboardData.userDetails.usertype,
                    imagePath: dashboardData.userDetails.filepath,
                    newsArticles: widget.newsArticles,
                  ),
                ),
              );
            }
          } else {
            _usernameErrorMessage =
                'Failed to load dashboard data. Please try again.';
            setState(() {});
          }
        } else {
          _isLoading = false;
          if (message == "Invalid Username") {
            _usernameErrorMessage = 'Please enter a valid username.';
          } else if (message == "Invalid Password") {
            _passwordErrorMessage = 'Please enter a valid password.';
          } else {
            _usernameErrorMessage = 'Invalid username or password.';
          }
          setState(() {});
        }
      } catch (e) {
        print('Error during login: $e');
        setState(() {
          _usernameErrorMessage =
              'An unexpected error occurred. Please try again.';
          _passwordErrorMessage = null;
        });
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _usernamecontroller.addListener(_updateLoginButtonState);
    _passwordcontroller.addListener(_updateLoginButtonState);
  }

  void dispose() {
    _usernamecontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

//enable button
  void _updateLoginButtonState() {
    setState(() {
      _isLoginEnabled = _usernamecontroller.text.isNotEmpty &&
          _passwordcontroller.text.isNotEmpty;
    });
  }

  //
  String _getLimitedHtmlContent(String content) {
    // You can set the character limit to simulate the first 3 lines.
    final maxCharacters =
        200; // Adjust the number of characters for 3 lines of text
    return content.length > maxCharacters
        ? content.substring(0, maxCharacters) + '...'
        : content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.appBackgroundPrimaryColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Center(
              child: Column(
                children: [
                  // Logo image
                  Image.asset(
                    AppTheme.appLogoImage,
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  // School name
                  Text(
                    AppTheme.appLogoName,
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'semibold',
                        height: 1.1,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  // Login text
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.005,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'semibold',
                          color: Colors.black),
                    ),
                  ),
                  // Username text box
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  //username textfield...
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'medium',
                      ),
                      controller: _usernamecontroller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: 'Enter Unique ID',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'medium',
                          color: Color.fromRGBO(62, 62, 62, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _usernameErrorMessage == null
                                ? AppTheme.textFieldborderColor
                                : Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _usernameErrorMessage == null
                                ? AppTheme.textFieldborderColor
                                : Colors.red,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _usernameErrorMessage == null
                                ? AppTheme.textFieldborderColor
                                : Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // username error text
                  if (_usernameErrorMessage != null)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _usernameErrorMessage!,
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'medium',
                              fontSize: 14),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 7,
                  ),
                  //password textfield....
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'medium',
                      ),
                      controller: _passwordcontroller,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'medium',
                          color: Color.fromRGBO(62, 62, 62, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _passwordErrorMessage == null
                                ? AppTheme.textFieldborderColor
                                : Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _passwordErrorMessage == null
                                ? AppTheme.textFieldborderColor
                                : Colors.red,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _passwordErrorMessage == null
                                ? AppTheme.textFieldborderColor
                                : Colors.red,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  // password error text..
                  if (_passwordErrorMessage != null)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _passwordErrorMessage!,
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'medium',
                              fontSize: 14),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  _isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 4,
                          color: AppTheme.textFieldborderColor,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.textFieldborderColor,
                              disabledBackgroundColor:
                                  Color.fromRGBO(246, 234, 208, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: _isLoginEnabled ? _login : null,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 16,
                                fontFamily: 'medium',
                              ),
                            ),
                          ),
                        ),
                  // Forget password
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.009),
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        fontFamily: 'medium',
                        color: Color.fromRGBO(29, 27, 32, 1),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: AppTheme.textFieldborderColor),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Latest News',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'bold',
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///fetched news data section..
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: AppTheme.appBackgroundPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            children: [
                              for (var article in widget.newsArticles)
                                Padding(
                                  padding: EdgeInsets.only(
                                    // left: 10,
                                    //  right: 10,
                                    //  top: 12,
                                    //  bottom: 10
                                    left: MediaQuery.of(context).size.width *
                                        0.025,
                                    right: MediaQuery.of(context).size.width *
                                        0.025,
                                    top: MediaQuery.of(context).size.height *
                                        0.015,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.black, width: 0.2),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      article.headline,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'medium',
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        article.postedOn,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(width: 5),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.black,
                                              thickness: 0.5,
                                            ),
                                            //
                                            Transform.translate(
                                              offset: Offset(-6, 0),
                                              child: Container(
                                                child: Html(
                                                  data: article.newsContent,
                                                  style: {
                                                    "body": Style(
                                                      color: Colors.black,
                                                      fontSize: FontSize(16),
                                                      fontFamily: 'semibold',
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  },
                                                ),
                                              ),
                                            ),
                                            //
                                            if (article.filePath
                                                    .contains('youtube.com') ||
                                                article.filePath
                                                    .contains('youtu.be'))
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigate to LoginVideo page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginVideo(
                                                                videoUrl: article
                                                                    .filePath),
                                                      ),
                                                    );
                                                  },
                                                  child: YoutubePlayer(
                                                    controller:
                                                        YoutubePlayerController(
                                                      initialVideoId:
                                                          YoutubePlayer
                                                              .convertUrlToId(
                                                                  article
                                                                      .filePath)!,
                                                      flags: YoutubePlayerFlags(
                                                          hideThumbnail: false,
                                                          autoPlay: false,
                                                          mute: false,
                                                          showLiveFullscreenButton:
                                                              false,
                                                          controlsVisibleAtStart:
                                                              false,
                                                          hideControls: true),
                                                    ),
                                                    showVideoProgressIndicator:
                                                        true,
                                                  ),
                                                ),
                                              )
                                            else
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Image.network(
                                                  article.filePath,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Text("");
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginVideo extends StatefulWidget {
  final String videoUrl;

  const LoginVideo({super.key, required this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<LoginVideo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Reset to portrait mode when exiting fullscreen
    _controller.addListener(() {
      if (!_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6), // Apply same opacity color
        ),
        child: Center(
          child: YoutubePlayerBuilder(
            onEnterFullScreen: () {
              // Allow rotation in fullscreen only
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
            onExitFullScreen: () {
              // Lock back to portrait when exiting fullscreen
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
            ),
            builder: (context, player) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  player, // Video Player centered
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
