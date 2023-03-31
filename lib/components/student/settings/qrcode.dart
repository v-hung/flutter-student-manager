import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void showModalQrCode(BuildContext context, String avatar, String qrcode, String name) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 1,
        minChildSize: 0.6,
        maxChildSize: 1,
        builder: (context, scrollController) => Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                image: DecorationImage(
                  image: AssetImage("assets/img/bg-qrcode.jpg"),
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 270,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 170,
                          height: 170,
                          child: CachedNetworkImage(
                            imageUrl: qrcode,
                            imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(name.toUpperCase(), style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700
                        ),),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -335),
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: CachedNetworkImage(
                        imageUrl: avatar,
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
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      );
    });
  }