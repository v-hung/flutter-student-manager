import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  var top = 250.0;
  var opacity = 1.0;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.qrcode,
                    color: top < 90 ? Colors.white : Colors.green
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text("Chỉnh sửa", style: TextStyle(
                      color: top < 90 ? Colors.white : Colors.green
                    ),)
                  ),
                ],
                floating: false,
                
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: LayoutBuilder(
                  builder: (ctx, cons)  {
                    final tempTop = top;
                    top = cons.biggest.height;
                    opacity = (top - 56) / 194;
                    return FlexibleSpaceBar(
                      background: Container(
                        color: Colors.grey[100],
                      ),
                      title: Text("Cài đặt", style: TextStyle(
                        color: tempTop < 90 ? Colors.white : Colors.green
                      ),),
                      centerTitle: true,
                    );
                  }
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("fsdafads", style: TextStyle(
                        color: Colors.green.withOpacity(opacity > 1 ? 1 : opacity < 0 ? 0 : opacity)
                      ),),
                      Container(
                        height: 1000,
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
              )
            ],
            // child: Container(
            //   child: TextButton(onPressed: () {
            //     ref.read(authControllerProvider.notifier).logout();
            //   }, child: Text("Đăng xuất")),
            // ),
          ),
          // _buildFab()
        ],
      ),
      bottomNavigationBar: const BottomNavBarStudent(),
    );
  }

  Widget _buildFab() {
    return Positioned(
      left: 0,
      right: 0,
      top: top,
      child: Center(
        child: Container(
          height: 20,
          child: Text("fsdafads", style: TextStyle(
            color: top < 90 ? Colors.white : Colors.green
          ),),
        ),
      ),
    );
  }
}