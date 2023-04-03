import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/pages/ErrorPage.dart';
import 'package:flutter_student_manager/pages/YouArePage.dart';
import 'package:flutter_student_manager/pages/student/home/HomeStudentPage.dart';
import 'package:flutter_student_manager/pages/student/home/breakschool/BreakSchoolPage.dart';
import 'package:flutter_student_manager/pages/student/home/calendar/CalendarPage.dart';
import 'package:flutter_student_manager/pages/student/home/classroom/ClassroomPage.dart';
import 'package:flutter_student_manager/pages/student/home/notifications/NotificationsPage.dart';
import 'package:flutter_student_manager/pages/student/home/tuition/TuitionPage.dart';
import 'package:flutter_student_manager/pages/student/settings/SettingsPage.dart';
import 'package:flutter_student_manager/pages/student/settings/edit/EditProfilePage.dart';
import 'package:flutter_student_manager/pages/student/study/StudyPage.dart';
import 'package:flutter_student_manager/pages/student/study/year/StudyYearPage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/components/page_transition.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/AuthModel.dart';
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
    final auth = _ref.read(authControllerProvider);
    
    if (auth.authState == AuthState.initial) return null;

    final areWeLoginIn = loginPages.indexWhere((e) => e == state.subloc);

    if (auth.authState != AuthState.login) {
      return areWeLoginIn >= 0 ? null : loginPages[0];
    }

    if (areWeLoginIn >= 0 || state.subloc == "/loading") {
      if (auth.type == AuthType.student) {
        return '/student';
      }
      else {
        return '/teacher';
      }

    }

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

    // student
    ShellRoute(
      // name: "student",
      // path: "/student",
      builder: (context, state, child) => child,
      // pageBuilder: (context, state, child) => buildPageWithDefaultTransition<void>(
      //   context: context, 
      //   state: state, 
      //   child: child,
      // ),
      routes: [
        GoRoute(
          name: "home-student",
          path: "/student",
          // builder: (context, state) => const HomeStudentPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const HomeStudentPage(),
          ),
          routes: [
            GoRoute(
              name: "notifications",
              path: "notifications",
              builder: (context, state) => const NotificationsPage(),
            ),
            GoRoute(
              name: "classroom",
              path: "classroom",
              builder: (context, state) => const ClassroomPage(),
            ),
            GoRoute(
              name: "calendar",
              path: "calendar",
              builder: (context, state) => const CalendarPage(),
            ),
            GoRoute(
              name: "break-school",
              path: "break-school",
              builder: (context, state) => const BreakSchoolPage(),
            ),
            GoRoute(
              name: "tuition",
              path: "tuition",
              builder: (context, state) => const TuitionPage(),
            ),
          ]
        ),
        GoRoute(
          name: "study",
          path: "/student/study",
          // builder: (context, state) => const StudyPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const StudyPage(),
          ),
          routes: [
            GoRoute(
              name: "study-year",
              path: "year",
              builder: (context, state) => const StudyYearPage()
            ),
          ]
        ),
        GoRoute(
          name: "settings",
          path: "/student/settings",
          // builder: (context, state) => const SettingsPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const SettingsPage(),
          ),
          routes: [
            GoRoute(
              name: "edit-profile",
              path: "edit",
              builder: (context, state) => const EditProfilePage()
            ),
          ]
        ),
      ]
    ),
  ];
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: "/loading",
    debugLogDiagnostics: true,
    refreshListenable: router,
    redirect: router._redirectLogin,
    routes: router._routers,
    errorBuilder: ((context, state) => const ErrorPage() ),
  );
});