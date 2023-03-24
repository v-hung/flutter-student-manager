import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}