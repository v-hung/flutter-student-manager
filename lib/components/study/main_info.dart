import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';

class StudyMainInfo extends ConsumerStatefulWidget {
  const StudyMainInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyMainInfoState();
}

class _StudyMainInfoState extends ConsumerState<StudyMainInfo> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const ItemInfoWidget(
              color: Colors.red,
              icon: CupertinoIcons.book_solid,
              title: "Học lực",
              value: "Giỏi",
            ),
            const ItemInfoWidget(
              color: Colors.indigo,
              icon: CupertinoIcons.star_fill,
              title: "Hạnh kiểm",
              value: "Tốt",
            ),
            const ItemInfoWidget(
              color: Colors.deepPurple,
              icon: CupertinoIcons.bookmark_solid,
              title: "Trung binhg các môn",
              value: "8.9",
            ),
            ItemInfoWidget(
              color: Colors.cyanAccent[700]!,
              icon: CupertinoIcons.person_solid,
              title: "Danh hiệu",
              value: "HS giỏi",
            ),
            ItemInfoWidget(
              color: Colors.lime[700]!,
              icon: CupertinoIcons.list_bullet,
              title: "Xếp hạng",
              value: "2",
            ),
            ItemInfoWidget(
              color: Colors.pink[700]!,
              icon: CupertinoIcons.folder_solid,
              title: "Buổi nghỉ",
              value: "10",
            ),
            ItemInfoWidget(
              color: Colors.yellow[700]!,
              icon: Icons.stacked_line_chart_rounded,
              title: "Thuộc diện",
              value: "Lên lớp",
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  Row(children: [
                    Icon(Icons.edit_note_rounded, color: Colors.yellow,),
                    const SizedBox(width: 5,),
                    Expanded(child: Text("Nhận xét của giáo viên", style: TextStyle(
                      color: Colors.grey[800]!, fontWeight: FontWeight.w500
                    ),)),
                  ],),
                  const SizedBox(height: 5,),
                  Text("Em cố gắng nhiều trong học tập. Cần rèn luyện nhiều hơn mốn Tiếng Anh.",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemInfoWidget extends ConsumerStatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  const ItemInfoWidget({required this.color, required this.icon,
    required this.title, required this.value, super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemInfoWidgetState();
}

class _ItemInfoWidgetState extends ConsumerState<ItemInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(children: [
        Icon(widget.icon, color: widget.color,),
        const SizedBox(width: 5,),
        Expanded(child: Text(widget.title, style: TextStyle(
          color: Colors.grey[800]!, fontWeight: FontWeight.w500
        ),)),
        const SizedBox(width: 5,),
        Text(widget.value, style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16
        ),)
      ],),
    );
  }
}