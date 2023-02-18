import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/utils/colors.dart';

class CustomTheme {
  static ThemeData customTheme = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: UiColorHelper.yellowColor, // <-- SEE HERE
      onPrimary: UiColorHelper.grayColor, // <-- SEE HERE
      onSurface: Color.fromARGB(255, 66, 125, 145), // <-- SEE HERE
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(color: UiColorHelper.grayColor),
      headline2: TextStyle(color: UiColorHelper.grayColor),
      headline3: TextStyle(color: UiColorHelper.grayColor),
      headline4: TextStyle(color: UiColorHelper.grayColor),
      headline5: TextStyle(color: UiColorHelper.grayColor),
      headline6: TextStyle(color: UiColorHelper.grayColor),
      subtitle1: TextStyle(color: UiColorHelper.grayColor),
      subtitle2: TextStyle(color: UiColorHelper.grayColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: UiColorHelper.grayColor),
      titleTextStyle: TextStyle(color: UiColorHelper.grayColor, fontWeight: FontWeight.w700),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: UiColorHelper.grayColor),
    /*timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteTextColor: UiColorHelper.grayColor,
      dialHandColor: UiColorHelper.yellowColor,
    ),*/
    /*dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: Colors.amber),
    ),*/
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: UiColorHelper.grayColor, // button text color
      ),
    ),
  );
}
