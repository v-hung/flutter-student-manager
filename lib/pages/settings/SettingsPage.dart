import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}