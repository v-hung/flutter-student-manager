import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherClassroomInfo extends ConsumerStatefulWidget {
  final String id;
  const TeacherClassroomInfo({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherClassroomInfoState();
}

class _TeacherClassroomInfoState extends ConsumerState<TeacherClassroomInfo> {
  // final List<String> images = [
  //   "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ecole_-_Salle_de_Classe_2.jpg/640px-Ecole_-_Salle_de_Classe_2.jpg",
  //   "https://upload.wikimedia.org/wikipedia/commons/1/1d/Klassenzimmer1930.jpg",
  // ];

  @override
  Widget build(BuildContext context) {
    final classroom = ref.watch(classroomFutureProvider(widget.id));
    return Container(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(classroomFutureProvider(widget.id).future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: classroom.when(
            // skipLoadingOnRefresh: false,
            data: (data) {
              List<String> images = [];
              if (data.images != null) {
                images = (jsonDecode(data.images!) as List<dynamic>).map((e) => toImage(e)).toList();
              }
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  if (images.isNotEmpty) ...[
                    CarouselSlider(
                      options: CarouselOptions(
                        // height: 400,
                        aspectRatio: 4/3,
                        viewportFraction: .95,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: images.map((e) {
                        return CachedNetworkImage(
                          imageUrl: e,
                          imageBuilder: (context, imageProvider) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        );
                      }).toList(),
                    ),
                  ],

                  if (images.isEmpty) ...[
                    CarouselSlider(
                      options: CarouselOptions(
                        // height: 400,
                        aspectRatio: 4/3,
                        viewportFraction: .95,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: ["assets/img/classroom_default2.jpg", "assets/img/classroom_default.jpg"].map((e) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: AssetImage(e), fit: BoxFit.cover),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
          
                  const SizedBox(height: 20,),

                  // Expanded(
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name, style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),),

                          const SizedBox(height: 10,),
                          Text(data.description ?? "Chưa có mô tả"),
          
                          const SizedBox(height: 20,),
          
                          const Text("Danh sách sinh viên", style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                          ),),
          
                          const SizedBox(height: 10,),

                          for(var i = 0; i < data.students.length; i++) ...[
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    child:  data.students[i].avatar != null ? CachedNetworkImage(
                                      imageUrl: data.students[i].getImage(),
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          // color: Colors.grey,
                                          image: DecorationImage(
                                            image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    )
                                    : Container(
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
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(data.students[i].name, style: const TextStyle(fontWeight: FontWeight.w500),),
                                      data.students[i].date_of_birth != null ? Text(DateFormat("dd/MM/yyy").format(data.students[i].date_of_birth!)) : const SizedBox(),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (data.students[i].getPhone() != "") ...[
                                    IconButton(
                                      onPressed: () async {
                                        var _url = Uri.parse('https://zalo.me/0399633237');
                                        
                                        if (!await launchUrl(_url)) {
                                          return showSnackBar(context: context, content: "Không thể mở zalo");
                                        }
                                      },
                                      icon: const Icon(CupertinoIcons.chat_bubble_2_fill, color: Colors.pink,)
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        var _url = Uri(scheme: 'tel', path: data.students[i].getPhone());
                                        if (!await launchUrl(_url)) {
                                          return showSnackBar(context: context, content: "Không thể gọi điện");
                                        }
                                      },
                                      icon: const Icon(CupertinoIcons.phone_circle_fill, color: Colors.green,)
                                    ),
                                  ],

                                  IconButton(
                                    onPressed: () => context.go('/teacher/students/${data.students[i].id}?classroomId=${data.id}'),
                                    icon: const Icon(CupertinoIcons.info, color: Colors.blue,)
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15,)
                          ]
                        ],
                      ),
                    ),
                  // )
                ],
              );
            }, 
            error: (e,__) => Center(child: Text(e.toString())), 
            loading: () => SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: const Center(child: CircularProgressIndicator())
            )
          ),
        ),
      ),
    );
  }
}