import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:go_router/go_router.dart';

class StudyUserInfoWidget extends ConsumerWidget {
  final bool moveInfo;
  const StudyUserInfoWidget({this.moveInfo = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final auth = ref.watch(authControllerProvider);
        return InkWell(
          onTap: () => moveInfo ? context.go('/study/year') : null,
          child: Container(
            // height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!)
              )
            ),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: CachedNetworkImage(
                    imageUrl: auth.user?.getImage() ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(auth.user?.name ?? "...", style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),),
                        const SizedBox(height: 5,),
                        const Text("Trường THPT Thái Nguyên | Lớp 11A3"),
                      ],
                    ),
                  ),
                ),
                if (moveInfo) ...[
                  const SizedBox(width: 5,),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(CupertinoIcons.right_chevron)
                  ),
                ],
                const SizedBox(width: 5,),
              ],
            ),
          ),
        );
      }
    );
  }
}