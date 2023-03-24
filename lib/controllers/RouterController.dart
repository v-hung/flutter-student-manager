import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/pages/YouArePage.dart';
import 'package:flutter_student_manager/pages/home/notifications/NotificationsPage.dart';
import 'package:flutter_student_manager/pages/settings/SettingsPage.dart';
import 'package:flutter_student_manager/pages/study/StudyPage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/components/page_transition.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/AuthModel.dart';
import 'package:flutter_student_manager/pages/home/HomePage.dart';
import 'package:flutter_student_manager/pages/LoadingPage.dart';
import 'package:flutter_student_manager/pages/LoginPage.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  final List<String> loginPages = ["/you-are", "/login"];

  RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, 
    (_, __) => notifyListeners());
  }

  String? _redirectLogin(_, GoRouterState state) {
    final authSate = _ref.read(authControllerProvider).authState;
    
    if (authSate == AuthState.initial) return null;

    final areWeLoginIn = loginPages.indexWhere((e) => e == state.subloc);

    if (authSate != AuthState.login) {
      return areWeLoginIn >= 0 ? null : loginPages[0];
    }

    if (areWeLoginIn >= 0 || state.subloc == "/loading") return '/';

    return null;    
  }

  List<RouteBase> get _routers => [
    GoRoute(
      name: "loading",
      path: "/loading",
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      name: "you-are",
      path: "/you-are",
      builder: (context, state) => const YouArePage(),
    ),
    GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) => LoginPage(type: state.queryParams['type'] ?? "parents"),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return child;
      },
      routes: [
        GoRoute(
          name: "home",
          path: "/",
          // builder: (context, state) => const HomePage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context, 
            state: state, 
            child: const HomePage(),
          ),
          routes: [
             GoRoute(
              name: "notifications",
              path: "notifications",
              builder: (context, state) => const NotificationsPage(),
            ),
          ]
        ),
        GoRoute(
          name: "study",
          path: "/study",
          // builder: (context, state) => const HomePage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context, 
            state: state, 
            child: const StudyPage(),
          )
        ),
        GoRoute(
          name: "settings",
          path: "/settings",
          // builder: (context, state) => const HomePage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context, 
            state: state, 
            child: const SettingsPage(),
          )
        ),
      ]
    )
  ];
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: "/loading",
    debugLogDiagnostics: true,
    refreshListenable: router,
    redirect: router._redirectLogin,
    routes: router._routers
  );
});