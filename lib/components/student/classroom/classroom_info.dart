import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_student_manager/controllers/student/ClassroomController.dart';
import 'package:flutter_student_manager/utils/utils.dart';

class ClassroomInfo extends ConsumerStatefulWidget {
  const ClassroomInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassroomInfoState();
}

class _ClassroomInfoState extends ConsumerState<ClassroomInfo> {
  // final List<String> images = [
  //   "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ecole_-_Salle_de_Classe_2.jpg/640px-Ecole_-_Salle_de_Classe_2.jpg",
  //   "https://upload.wikimedia.org/wikipedia/commons/1/1d/Klassenzimmer1930.jpg",
  // ];

  @override
  Widget build(BuildContext context) {
    final classroom = ref.watch(classroomFutureProvider);
    return Container(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(classroomFutureProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: classroom.when(
            // skipLoadingOnRefresh: false,
            data: (data) {
              if (data == null) {
                return const Center( child: Text("Chưa có dữ liệu lớp học"),);
              }

              List<String> images = [];
              if (data.images != null) {
                images = (jsonDecode(data.images!) as List<dynamic>).map((e) => toImage(e)).toList();
                if (images.isEmpty) {
                  images = ["assets/img/classroom_default2.jpg", "assets/img/classroom_default.jpg"];
                }
              }
              return Column(
                children: [
                  const SizedBox(height: 10,),
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
                    items: images.isNotEmpty ? images.map((e) {
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
                    }).toList()
                    : ["assets/img/classroom_default2.jpg", "assets/img/classroom_default.jpg"].map((e) {
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
          
                  const SizedBox(height: 20,),
          
                  // Expanded(
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name, style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                          ),),
          
                          const SizedBox(height: 10,),
          
                          Text(data.description ?? "Chưa cập nhập mô tả lớp"),
          
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  // )
                ],
              );
            }, 
            error: (e,__) => Text(e.toString()), 
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