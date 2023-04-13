import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

final isScanCompletedProvider = StateProvider<bool>((ref) {
  return false;
});

Future createCodeScan(String uid) async {
  return await Future.delayed(const Duration(milliseconds: 100));
}

class TeacherQrCodePage extends ConsumerStatefulWidget {
  final String type;
  const TeacherQrCodePage({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherQrCodePageState();
}

class _TeacherQrCodePageState extends ConsumerState<TeacherQrCodePage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanCompleted = false;

  Future send(String uid) async {
    if (isScanCompleted) {
      return;
    }

    setState(() {
      isScanCompleted = true;
    });
    final data = await ref.read(teacherRepositoryProvider).createQrCode(uid);

    print(data);

    await showAlert(context);

    setState(() {
      isScanCompleted = false;
    });
  }
  
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isScanCompleted = ref.watch(isScanCompletedProvider);
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
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(isScanCompleted.toString()),
                TextButton(onPressed: () => send("s5s108dfc"), child: Text("click")),
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
                          // ref.read(isScanCompletedProvider.notifier).state = true;
                          isScanCompleted = true;
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
          isScanCompleted ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ) : const SizedBox()
        ],
      ),
    );
  }
}

Future showAlert(BuildContext context) async {
  return showDialog(context: context, builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          IntrinsicHeight(
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Text("Nguyễn Việt Hùng", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 5,),
                Text("Con đã đến lớp"),
                const SizedBox(height: 20,),
              ],
            ),
          ),
          Positioned(
            top: -40,
            child: SizedBox(
              height: 80,
              width: 80,
              child: CachedNetworkImage(
                imageUrl: "data.getImage()",
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.green,
                        Colors.orange,
                      ],
                    ),
                    image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.green,
                          Colors.orange,
                        ],
                      ),
                    ),
                    child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 50,)
                  )
                ),
              )
            ),
          )
        ],
      ),
    );
  });
}