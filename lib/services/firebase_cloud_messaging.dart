import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseCloudMessagingRepository {
  final Ref ref;
  final FirebaseMessaging fcm;

  FirebaseCloudMessagingRepository({
    required this.ref,
    required this.fcm,
  }) {
    init();
  }

  Future init() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }
  
}

final firebaseCloudMessagingRepositoryProvider = Provider((ref) {
  return FirebaseCloudMessagingRepository(fcm: FirebaseMessaging.instance, ref: ref);
});