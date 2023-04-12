import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

final isScanCompletedProvider = StateProvider<bool>((ref) {
  return false;
});

class TeacherQrCodePage extends ConsumerStatefulWidget {
  final String type;
  const TeacherQrCodePage({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherQrCodePageState();
}

class _TeacherQrCodePageState extends ConsumerState<TeacherQrCodePage> {
  MobileScannerController cameraController = MobileScannerController();
  
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isScanCompleted = ref.watch(isScanCompletedProvider);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: [0.5, 1.0],
            ),
          ),
        ),
        leading: IconButton(onPressed: () {
          context.go('/teacher');
        }, icon: const Icon(CupertinoIcons.back)),
        title: Text(widget.type == "in" ? "Quét giờ vào" : "Quét giờ ra"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(CupertinoIcons.lightbulb, color: Colors.white);
                  case TorchState.on:
                    return const Icon(CupertinoIcons.lightbulb_fill, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(CupertinoIcons.switch_camera);
                  case CameraFacing.back:
                    return const Icon(CupertinoIcons.switch_camera_solid);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text(isScanCompleted.toString()),
            TextButton(onPressed: () {
              ref.read(isScanCompletedProvider.notifier).state = !isScanCompleted;
            }, child: Text("click")),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Đặt mã QR trong khu vực máy ảnh", style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1
                ),),
                SizedBox(height: 5,),
                Text("Quá trình quét mã sẽ diễn ra tự động", style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                ),)
              ],
            )),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration( 
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(3)
                ),
                clipBehavior: Clip.hardEdge,
                child: MobileScanner(
                  // fit: BoxFit.contain,
                  controller: cameraController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (!isScanCompleted) {
                      ref.read(isScanCompletedProvider.notifier).state = true;
                      String code = barcodes[0].rawValue ?? "";
                      context.go('/teacher/qrcode/$code?type=${widget.type}');
                    }
                  },
                ),
              ),
            ),
            const Expanded(child: Center(
              child: Text("Sao Thái Nguyên", style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1
              ),),
            )),
          ],
        ),
      ),
    );
  }
}