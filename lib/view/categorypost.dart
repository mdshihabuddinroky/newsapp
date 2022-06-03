import 'package:asilation/view/imagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:asilation/controller/categorypostcontroller.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details.dart';

class Categorypost extends StatelessWidget {
  final String categoryname;
  const Categorypost({
    Key? key,
    required this.categoryname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoryPostcontroller postcontroller =
        Get.put(CategoryPostcontroller(categoryname));
    return Scaffold(appBar: AppBar(iconTheme: const IconThemeData(color: Colors.black),backgroundColor: Colors.white,title: Text(categoryname,style: GoogleFonts.dmSans(color: Colors.black),),),
        body: Obx(() => (postcontroller.postlist != null)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: postcontroller.postlist.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.to( Details(id:postcontroller.postlist[index].docId!,title: postcontroller.postlist[index].title!,image: postcontroller.postlist[index].image!,content: postcontroller.postlist[index].content!,));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Imagewid(url: postcontroller.postlist[index].image!,height: 90,width:120,)


                        ),
                        const SizedBox(width: 10,)
                        , Flexible(child: Text(postcontroller.postlist[index].title!,overflow: TextOverflow.ellipsis,maxLines: 2,style: GoogleFonts.dmSans(fontWeight: FontWeight.bold,fontSize: 20),))
                      ],),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              )));
  }
}
