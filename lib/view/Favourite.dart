import 'dart:convert';


import 'package:asilation/view/imagewidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var Favourite = [].obs;

    Getdata() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var favoriteList = prefs.getStringList('favoritelistdata') ?? [];
      Favourite(favoriteList);

    }
    Getdata();
    return Scaffold(

      body: Center(
          child: Obx(() {
            return Scaffold(body: (Favourite.isNotEmpty)?ListView.builder(

                itemCount: Favourite.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map = jsonDecode(Favourite[index]);

                  return GestureDetector(
                    onTap: (){

                      Get.to( Details(id:map['docId'],title: map['title'],image: map['image'],content: map['content']));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                          Imagewid( url: map['image'],height: 90,width:120)
                         ,),
                        const SizedBox(width: 10,)
                        , Flexible(child: Text(map['title'],overflow: TextOverflow.ellipsis,maxLines: 2,style: GoogleFonts.dmSans(fontWeight: FontWeight.bold,fontSize: 20),))
                      ],),
                    ),
                  );


                    //Text(map['title']);
                }

            ): Center(child: Text('No Favourite Post Available',style: GoogleFonts.sansita(fontSize: 20),)),);
          })
      ),
    );
  }
}
