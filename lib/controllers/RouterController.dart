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
import 'package:flutter_student_manager/pages/teacher/home/classrooms/TeacherClassroomPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/classrooms/details/ClassroomDetailsPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/HomeTeacherPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/notifications/TeacherNotificationsPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/qrcode/QrCodePage.dart';
import 'package:flutter_student_manager/pages/teacher/home/qrcode/details/QrCodeDetailsPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/students/details/TeacherStudentDetailsPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/students/edit-add/TeacherStudentEditAddPage.dart';
import 'package:flutter_student_manager/pages/teacher/settings/SettingsPage.dart';
import 'package:flutter_student_manager/pages/teacher/home/students/StudentsPage.dart';
import 'package:flutter_student_manager/pages/teacher/settings/edit/TeacherSettingsEdit.dart';
import 'package:flutter_student_manager/pages/teacher/study/StudyPage.dart';
import 'package:flutter_student_manager/pages/teacher/study/classroom/StudyClassroomPage.dart';
import 'package:flutter_student_manager/pages/teacher/study/student/StudyStudentPage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/components/page_transition.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/AuthModel.dart';
import 'package:flutter_student_manager/pages/LoadingPage.dart';
import 'package:flutter_student_manager/pages/LoginPage.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  final List<String> loginPages = ["/", "/login"];

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
      else if (auth.type == AuthType.teacher) {
        return '/teacher';
      }
      else {
        return '/';
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
      path: "/",
      builder: (context, state) => const YouArePage(),
      routes: [
        GoRoute(
          name: "login",
          path: "login",
          builder: (context, state) => LoginPage(type: state.queryParams['type'] ?? "parents"),
        ),
      ]
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
          name: "student-home",
          path: "/student",
          // builder: (context, state) => const HomeStudentPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const HomeStudentPage(),
          ),
          routes: [
            GoRoute(
              path: "notifications",
              builder: (context, state) => const NotificationsPage(),
            ),
            GoRoute(
              path: "classroom",
              builder: (context, state) => const ClassroomPage(),
            ),
            GoRoute(
              path: "calendar",
              builder: (context, state) => const CalendarPage(),
            ),
            GoRoute(
              path: "break-school",
              builder: (context, state) => const BreakSchoolPage(),
            ),
            GoRoute(
              path: "tuition",
              builder: (context, state) => const TuitionPage(),
            ),
          ]
        ),
        GoRoute(
          path: "/student/study",
          // builder: (context, state) => const StudyPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const StudyPage(),
          ),
          routes: [
            GoRoute(
              path: "year",
              builder: (context, state) => const StudyYearPage()
            ),
          ]
        ),
        GoRoute(
          path: "/student/settings",
          // builder: (context, state) => const SettingsPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const SettingsPage(),
          ),
          routes: [
            GoRoute(
              path: "edit",
              builder: (context, state) => const EditProfilePage()
            ),
          ]
        ),
      ]
    ),

    // teacher
    ShellRoute(
      // name: "teacher",
      // path: "/teacher",
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          name: "home-teacher",
          path: "/teacher",
          // builder: (context, state) => const HomeStudentPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const HomeTeacherPage(),
          ),
          routes: [
            GoRoute(
              path: "notifications",
              builder: (context, state) => const TeacherNotificationsPage(),
            ),
            GoRoute(
              path: "classrooms",
              builder: (context, state) => const TeacherClassroomPage(),
              routes: [
                GoRoute(
                  path: ":id",
                  builder: (context, state) => ClassroomDetailsPage(id: state.params['id'] ?? "")
                ),
              ]
            ),
            GoRoute(
              path: "students",
              builder: (context, state) => const TeacherStudentsPage(),
              routes: [
                GoRoute(
                  name: "teacher-student-edit-add",
                  path: "edit-add",
                  builder: (context, state) => TeacherStudentEditAddPage(id: state.queryParams['id'] ?? "")
                ),
                GoRoute(
                  name: "teacher-student-info",
                  path: ":id",
                  builder: (context, state) => TeacherStudentDetailsPage(id: state.params['id'] ?? "")
                ),
              ]
            ),
            GoRoute(
              path: "qrcode",
              builder: (context, state) => TeacherQrCodePage(type: state.queryParams['type'] ?? "in"),
              routes: [
                GoRoute(
                  path: ":value",
                  builder: (context, state) => TeacherQrCodeDetailsPage(value: state.params['value'] ?? "", type: state.queryParams['type'] ?? "",)
                )
              ]
            ),
          ]
        ),
        
        GoRoute(
          path: "/teacher/study",
          builder: (context, state) => const HomeStudentPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const TeacherStudyPage(),
          ),
          routes: [
            GoRoute(
              path: "classroom",
              builder: (context, state) => const StudyClassroomPage(),
            ),
            GoRoute(
              path: ":id",
              builder: (context, state) => StudyStudentPage(id: state.params['id'] ?? ""),
            ),
          ]
        ),
        
        
        GoRoute(
          path: "/teacher/settings",
          // builder: (context, state) => const HomeStudentPage(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, 
            state: state, 
            child: const TeacherSettingsPage(),
          ),
          routes: [
            GoRoute(
              path: "edit",
              builder: (context, state) => const TeacherSettingsEditPage()
            ),
          ]
        )
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