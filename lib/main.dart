import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/services/theme_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_student_manager/controllers/RouterController.dart';
import 'package:flutter_student_manager/utils/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const ProviderScope(child: MyApp()));
  // initializeDateFormatting()
  //   .then((value) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appTheme = ref.watch(appThemeProvider);
    return MaterialApp.router(
      title: 'Flutter Chat App',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
        Locale('vi'), // arabic, no country code
      ],
      theme: appTheme.themeData,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}