import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
import 'package:flutter_application_1/screens/Dashboard.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_Name.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

//login function....

  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernamecontroller.text;
      String password = _passwordcontroller.text;
      print('Attempting to login with Username: $username');

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  username: dashboardData.userDetails.username,
                  userType: dashboardData.userDetails.usertype,
                  imagePath: dashboardData.userDetails.filepath,
                ),
              ),
            );
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
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
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
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
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
                          width: MediaQuery.of(context).size.width * 0.4,
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
                      color: Color.fromRGBO(242, 247, 249, 1),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'News',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'bold',
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary:
                                                AppTheme.textFieldborderColor,
                                            onPrimary: Colors.black,
                                            surface: Colors.black,
                                            onSurface: Colors.white,
                                          ),
                                          dialogBackgroundColor: Colors.black,
                                          textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                          ))),
                                      child: child!,
                                    );
                                  });

                              if (selectedDate != null) {
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(selectedDate);
                                print("Selected date: $formattedDate");
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/images/Calender_icon.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///fetched news data section..
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Color.fromRGBO(242, 247, 249, 1),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            children: [
                              for (var article in widget.newsArticles)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 12),
                                  child: Card(
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
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
                                                          fontFamily: 'medium',
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(width: 5),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.009,
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.black,
                                              thickness: 0.5,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.006,
                                            ),
                                            Text(
                                              article.newsContent,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'regular',
                                                  color: Colors.black),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.010,
                                            ),
                                            Text(
                                              'Continue Reading...',
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    252, 190, 58, 1),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.010,
                                            ),
                                            Image.network(
                                              article.filePath,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(height: 10),
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
