import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomeListNotification extends ConsumerStatefulWidget {
  const HomeListNotification({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeListNotificationState();
}

class _HomeListNotificationState extends ConsumerState<HomeListNotification> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // final auth = ref.watch(authControllerProvider);
        return Container(
        );
      }
    );
  }
}