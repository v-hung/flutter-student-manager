import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/utils/color.dart';

class YouArePage extends ConsumerStatefulWidget {
  const YouArePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => YouArePageState();
}

class YouArePageState extends ConsumerState<YouArePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Lựa chọn tài khoản", style: TextStyle(
                  color: Colors.grey[700]!,
                  fontWeight: FontWeight.w500
                ),),
                const SizedBox(height: 5,),
                const Text("Bạn là?", style: TextStyle(
                  // color: Colors.grey[700]!,
                  fontSize: 26,
                  fontWeight: FontWeight.w700
                ),),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () => context.go('/login?type=teacher'),
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(
                              "assets/img/teacher.png"
                            ))
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Giáo viên", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                              ),),
                              const SizedBox(height: 5,),
                              Text("Tạo và quản lý lớp học của bạn", style: TextStyle(
                                color: Colors.grey[700]!,
                                // fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () => context.go('/login?type=student'),
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(
                              "assets/img/family.png"
                            ))
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Phụ huynh", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                              ),),
                              const SizedBox(height: 5,),
                              Text("Giữ kết nối với con bạn trên lớp", style: TextStyle(
                                color: Colors.grey[700]!,
                                // fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}