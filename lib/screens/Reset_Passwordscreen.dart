import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Reset_password/reset_password_model.dart';
import 'package:flutter_application_1/services/Restpassword_Api/Resetpassword_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

class ResetPasswordscreen extends StatefulWidget {
  const ResetPasswordscreen({super.key});

  @override
  State<ResetPasswordscreen> createState() => _ResetPasswordscreenState();
}

class _ResetPasswordscreenState extends State<ResetPasswordscreen> {
  //
  TextEditingController enterpassword = TextEditingController();
  TextEditingController confirm = TextEditingController();

  //

  String? _errorText;

  void _validatePasswords() {
    setState(() {
      if (enterpassword.text.isNotEmpty &&
          confirm.text.isNotEmpty &&
          enterpassword.text != confirm.text) {
        _errorText = "Passwords do not match!";
      } else {
        _errorText = null;
      }
    });
  }

  bool _isPasswordVisible = false;

  bool _isconfirmVisible = false;
  //
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundPrimaryColor,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    color: Colors.white),
                child: SvgPicture.asset(
                  'assets/icons/enddawer_lockicon.svg',
                  color: Color.fromRGBO(252, 190, 58, 1),
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
              ),
              //
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      fontFamily: 'semibold',
                      fontSize: 24,
                      color: Colors.black),
                ),
              ),
              //
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: enterpassword,
                    obscureText: !_isPasswordVisible,
                    maxLength: 50,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Your new Password',
                      hintStyle: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                          color: Colors.black),
                      counterText: "",
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your new password';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              //
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.012),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: confirm,
                    obscureText: !_isconfirmVisible,
                    maxLength: 50,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Confirm Your Password',
                      hintStyle: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                          color: Colors.black),
                      counterText: "",
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 0.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isconfirmVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _isconfirmVisible = !_isconfirmVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your confirm password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              //Error Message
              if (_errorText != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    _errorText!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              //
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.030),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        backgroundColor: AppTheme.textFieldborderColor),
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                        _validatePasswords();
                      //
                      resetUserPassword();
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              //
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.005),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          backgroundColor: Color.fromRGBO(240, 240, 240, 1)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 14,
                            color: Colors.black),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  void resetUserPassword() async {
    ResetPasswordService service = ResetPasswordService();
    ResetPasswordModel model = ResetPasswordModel(
      rollNumber: UserSession().rollNumber ?? '',
      userType: UserSession().userType ?? '',
      password: confirm.text,
    );
    String response = await service.resetPassword(model, context);
    print(response);
  }
}
