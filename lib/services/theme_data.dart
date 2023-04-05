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
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      }
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xfff0f2f5),
    appBarTheme: const AppBarTheme(
      color: Colors.green,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      titleTextStyle:  TextStyle(
        color: Colors.white,
        fontSize: 16, 
        fontWeight: FontWeight.w600
      ),
      iconTheme: IconThemeData(
        size: 20,
        color: Colors.white
      ),
    ),
    primaryColor: Colors.green,
    colorScheme: ColorScheme.light().copyWith(
      primary: Colors.green,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // backgroundColor: primary2,
        minimumSize: const Size(double.infinity, 48),
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.green,
        foregroundColor : Colors.white,
      ),
    ),
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     // foregroundColor: primary
    //   )
    // ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey[900]!),
    ),
    // iconTheme: IconThemeData(
    //   color: Colors.grey[900]
    // ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[500]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[500]!),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
    ),
    tabBarTheme: TabBarTheme(
      labelPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ]
      ),
      labelColor: Colors.green[700],
      unselectedLabelColor: Colors.black,
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.green,
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)
      ),
      elevation: 0,
    )
  ));
});