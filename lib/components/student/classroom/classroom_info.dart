import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ClassroomInfo extends ConsumerStatefulWidget {
  const ClassroomInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassroomInfoState();
}

class _ClassroomInfoState extends ConsumerState<ClassroomInfo> {
  final List<String> images = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ecole_-_Salle_de_Classe_2.jpg/640px-Ecole_-_Salle_de_Classe_2.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/1/1d/Klassenzimmer1930.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
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

            const SizedBox(height: 20,),

            // Expanded(
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Lớp 12A2", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                    ),),

                    const SizedBox(height: 10,),

                    Text("Lorem ipsum dolor sit amet consectetur adipisicing elit. Itaque perspiciatis explicabo aliquid ullam ducimus, optio voluptas voluptates ea illo a delectus nostrum labore! Totam, eos ipsum! Tenetur sunt expedita quis!"),

                    const SizedBox(height: 10,),

                    Text("Thông tin liên hệ", style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),),

                    const SizedBox(height: 10,),

                    Container(
                      width: double.infinity,
                      child: DataTable(
                        // columnSpacing: 83,
                        headingRowHeight: 0,
                        // dataRowHeight: 30,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                        ],
                        rows: const <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Email", style: TextStyle(fontWeight: FontWeight.w500),maxLines: 1,)),
                              DataCell(Text('viet.hung.2898@gmail.com')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Địa chỉ", style: TextStyle(fontWeight: FontWeight.w500),maxLines: 1,)),
                              DataCell(Text('Sớn Tiến - Quyết Thắng - Thái Nguyên')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Số điện thoại", style: TextStyle(fontWeight: FontWeight.w500), maxLines: 1,)),
                              DataCell(Text('0399 633 237')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // )
          ],
        ),
      ),
    );
  }
}