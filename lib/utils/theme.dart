import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );
  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      displayLarge: TextStyle(),
    ),
  );

  //customized AppTheme....

  //app Logo
  static const String appLogoImage = 'assets/images/splashscreen_image.png';

  //app Logo Name
  static const String appLogoName = 'Morning Star \n Matriculation School';

  //app Logo taglines
  static const String appSubtitle = 'WHERE EVERY STUDENT THRIVES';

  //app primary color
  static const Color appBackgroundPrimaryColor =
      Color.fromRGBO(255, 253, 247, 1);

  //textfield bordercolor..
  static const textFieldborderColor = Color.fromRGBO(252, 190, 58, 1);

  //count color..gradient color......
  static const Color gradientStartColor = Color.fromRGBO(251, 174, 78, 1);
  static const Color gradientEndColor = Color.fromRGBO(235, 130, 0, 1);

  //carousel dots color
  static const carouselDotActiveColor = Color.fromRGBO(252, 190, 58, 1);
  static const carouselDotUnselectColor = Color.fromRGBO(252, 190, 58, 0.5);

  //Add icon color
  static const Addiconcolor = Color.fromRGBO(255, 179, 16, 1);

  //menu Item text Dashboard First section Text
  static const menuTextColor = Color.fromRGBO(24, 24, 24, 1);
}
