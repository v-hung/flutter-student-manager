import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/services/theme_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_student_manager/controllers/RouterController.dart';
import 'package:flutter_student_manager/utils/color.dart';

void main() async {
  initializeDateFormatting();
  runApp(const ProviderScope(child: MyApp()));
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
      theme: appTheme.themeData,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}