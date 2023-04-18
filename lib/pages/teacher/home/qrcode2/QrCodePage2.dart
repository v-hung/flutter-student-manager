import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

class TeacherQrCodePage2 extends ConsumerStatefulWidget {
  final String type;
  const TeacherQrCodePage2({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherQrCodePage2State();
}

class _TeacherQrCodePage2State extends ConsumerState<TeacherQrCodePage2> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanCompleted = false;

  Future send(String uid, ) async {
    if (isScanCompleted) {
      return;
    }

    setState(() {
      isScanCompleted = true;
    });

    print(uid);

    final data = await ref.read(teacherRepositoryProvider).createQrCode2(uid, widget.type, DateTime.now().toString());

    if (data != null) {
      if (context.mounted) {
        await showAlertSuccess2(context, data.teacher, widget.type);
      }
    }
    else {
      if (context.mounted) {
        await showAlertFailed(context);
      }
    }

    setState(() {
      isScanCompleted = false;
    });
  }
  
  @override
  void dispose() {
    // cameraController.dispose();
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
        title: Text(widget.type == "in" ? "Điểm danh giờ vào" : "Điểm danh giờ ra"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(CupertinoIcons.bolt, color: Colors.white);
                  case TorchState.on:
                    return const Icon(CupertinoIcons.bolt_fill, color: Colors.yellow);
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
                          String code = barcodes[0].rawValue ?? "";
                          print('send');
                          send(code);
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

Future showAlertSuccess(BuildContext context, StudentModel student, String type) async {
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
                Text(student.name, style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 5,),
                type == "in" ? const Text("Con đã đến lớp") : const Text("Con đã ra về"),
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
                imageUrl: student.getImage(),
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

Future showAlertSuccess2(BuildContext context, TeacherModel teacher, String type) async {
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
                Text(teacher.name, style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 5,),
                Text("${teacher.name} đã ${type == "in" ? "đến lớp" : "ra về"}"),
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
                imageUrl: teacher.getImage(),
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

Future showAlertFailed(BuildContext context) async {
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
              children: const [
                SizedBox(height: 50,),
                Text("Thất bại", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 5,),
                Text("Không thể quét mã, vui lòng thử lại"),
                SizedBox(height: 20,),
              ],
            ),
          ),
          Positioned(
            top: -40,
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red
              ),
              child: const Icon(CupertinoIcons.exclamationmark, color: Colors.white, size: 30,)
            ),
          )
        ],
      ),
    );
  });
}