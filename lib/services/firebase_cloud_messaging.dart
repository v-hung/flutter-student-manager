import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/controllers/RouterController.dart';
import 'package:flutter_student_manager/controllers/teacher/BreakSchoolController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/services/local_notifications.dart';
import 'package:go_router/go_router.dart';

class FirebaseCloudMessagingService {
  final Ref ref;
  final FirebaseMessaging fcm;
  NotificationSettings? settings;

  FirebaseCloudMessagingService({
    required this.ref,
    required this.fcm,
  }) {
    init();
    ref.listen(authControllerProvider, 
    (oldValue, newValue) {
      if (oldValue?.user == null && newValue.user != null) {
        subscribeToTopic(newValue.user);
      }
      else if (oldValue?.user != null && newValue.user == null) {
        unsubscribeFromTopic(oldValue?.user);
      }
    });
  }

  Future init() async {
    settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingOpenedAppHandler);

    // print(await fcm.getToken());
  }
  

  Future _firebaseMessagingForegroundHandler(RemoteMessage event) async {
    print(event);
    if (event.notification != null) {
      var id = DateTime.now().microsecond;
      ref.read(breakSchoolControllerProvider.notifier).loadData();
      ref.read(localNotificationServiceProvider).showNotification(id, event.notification!.title, event.notification!.body); 
    }
  }

  Future _firebaseMessagingOpenedAppHandler(RemoteMessage message) async {
    // print("Handling a opened app message: ${message .messageId}");
    ref.read(localNotificationServiceProvider).openedNotification(null);
  }

  Future subscribeToTopic(dynamic user) async {
    // final user = ref.watch(authControllerProvider).user;
    if (user is StudentModel) {
      await fcm.subscribeToTopic("students");
      if (user.class_id != null) {
        await fcm.subscribeToTopic("classroom-${user.class_id}");
      }
      await fcm.subscribeToTopic("student-${user.id}");
    }
    else if (user is TeacherModel) {
      await fcm.subscribeToTopic('teachers');
    }
  }

  Future unsubscribeFromTopic(dynamic user) async {
    // final user = ref.watch(authControllerProvider).user;
    if (user is StudentModel) {
      await fcm.unsubscribeFromTopic("students");
      if (user.class_id != null) {
        await fcm.unsubscribeFromTopic("classroom-${user.class_id}");
      }
      await fcm.unsubscribeFromTopic("student-${user.id}");
    }
    else if (user is TeacherModel) {
      await fcm.unsubscribeFromTopic('teachers');
    }
  }
}

final firebaseCloudMessagingServiceProvider = Provider((ref) {
  return FirebaseCloudMessagingService(fcm: FirebaseMessaging.instance, ref: ref);
});