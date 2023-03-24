// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/utils/color.dart';

class AppTheme {
  final ThemeData themeData;

  AppTheme({
    required this.themeData,
  });
}

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme(themeData: ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      // foregroundColor: primary,
      titleTextStyle: TextStyle(fontSize: 18, 
        // color: primary, 
        fontWeight: FontWeight.w600),
      iconTheme: IconThemeData(
        size: 20
      )
    ),
    // scaffoldBackgroundColor: primary4,
    // primarySwatch: primary,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      // primary: primary2,
    ),
    // fontFamily: 'Arial',
    // primaryColor: primary,
    // indicatorColor: primary2,
    // primaryColorLight: primary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // backgroundColor: primary2,
        minimumSize: const Size(double.infinity, 48),
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // foregroundColor: primary
      )
    ),
    textTheme: const TextTheme(
      // bodyMedium: TextStyle(color: primary),
    ),
    iconTheme: const IconThemeData(
      // color: primary
    ),
    inputDecorationTheme: const InputDecorationTheme(
      // labelStyle: TextStyle(color: primary),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(
      //     style: BorderStyle.solid, 
      //     color: primary
      //   ),
      // )
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
    ),
    tabBarTheme: const TabBarTheme(
      // labelColor: primary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      // color: primary2
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)
      )
    )
  ));
});