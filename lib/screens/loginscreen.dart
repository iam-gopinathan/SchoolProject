import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Dashboard.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

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

  // Add these two variables to store the error messages
  String? _usernameErrorMessage;
  String? _passwordErrorMessage;

//login function....
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernamecontroller.text;
      String password = _passwordcontroller.text;
      print('Attempting to login with Username: $username');

      try {
        final response = await _authService.login(username, password);

        if (response['success']) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          setState(() {
            _usernameErrorMessage = 'Username is not valid';
            _passwordErrorMessage =
                response['passwordError'] ?? 'Password is not valid';
          });
        }
      } catch (e) {
        print('Error during login: $e');
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Add listeners to update button state based on input
    _usernamecontroller.addListener(_updateLoginButtonState);
    _passwordcontroller.addListener(_updateLoginButtonState);
  }

  void dispose() {
    _usernamecontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  void _updateLoginButtonState() {
    setState(() {
      // Enable the button only if both fields are not empty
      _isLoginEnabled = _usernamecontroller.text.isNotEmpty &&
          _passwordcontroller.text.isNotEmpty;
    });
    // Add a listener to track changes in the username field
    _usernamecontroller.addListener(() {
      setState(() {
        // Update the border color based on whether the username field has any text
        // _isUsernameValid = _usernamecontroller.text.isNotEmpty;
      });
    });
    // Add listener to password controller
    _passwordcontroller.addListener(() {
      setState(() {
        // _isPasswordValid = _passwordcontroller.text.isNotEmpty;
      });
    });
  }

  // New variables to track validation status
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(255, 253, 247, 1),
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
                    'assets/images/splashscreen_image.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  // School name
                  Text(
                    'Morning Star \n Matriculation School',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'semibold',
                      height: 1.1,
                    ),
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
                      ),
                    ),
                  ),
                  // Username text box
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
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
                            color: Color.fromRGBO(62, 62, 62, 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(252, 190, 58, 1),
                                width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(252, 190, 58, 1),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(252, 190, 58, 1),
                                width: 2)),
                      ),
                    ),
                  ),
                  // Show error message below the username field
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
                              color: Color.fromRGBO(252, 190, 58, 1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(252, 190, 58, 1),
                            width: 2.0,
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
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(252, 190, 58, 1),
                                width: 2)),
                      ),
                    ),
                  ),
                  // Show error message below the password field
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(252, 190, 58, 1),
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
                  // News and calendar section (fixed)
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
                          SvgPicture.asset(
                            'assets/images/Calender_icon.svg',
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //cards scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Color.fromRGBO(242, 247, 249, 1),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            children: [
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'News',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'medium',
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '10/10/2024',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '|',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '2.44PM',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
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
                                                0.004,
                                          ),
                                          Text(
                                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s....',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'regular',
                                                color: Colors.black),
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
                                          Image.asset(
                                            'assets/images/school_bannerimg.png',
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
