import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/BreakSchoolModel.dart';
import 'package:intl/intl.dart';

class NotificationTeacherWidget extends ConsumerStatefulWidget {
  final BreakSchoolModel breakSchool;
  const NotificationTeacherWidget({required this.breakSchool, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationTeacherWidgetState();
}

class _NotificationTeacherWidgetState extends ConsumerState<NotificationTeacherWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: widget.breakSchool.student?.avatar != null ? CachedNetworkImage(
            imageUrl: widget.breakSchool.student!.getImage(),
            imageBuilder: (context, imageProvider) => Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green,
                image: DecorationImage(
                  image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) => Center(child: Container(
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
              child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 20,)
            )),
          )
          : Center(child: Container(
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
            child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 20,)
          ))
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.breakSchool.student?.name ?? "Ai đó", style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                    const SizedBox(width: 5,),
                    Text(DateFormat("dd/MM/yyy").format(widget.breakSchool.date), style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800]
                    ),),
                  ],
                ),
                const SizedBox(height: 5,),
                Text(widget.breakSchool.reason),
              ],
            ),
          ),
        ),
      ],
    );
  }
}