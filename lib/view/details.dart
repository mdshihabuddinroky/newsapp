import 'dart:convert';


import 'package:asilation/view/imagewidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatelessWidget {
  const Details({Key? key, required this.id, required this.content, required this.image, required this.title}) : super(key: key);
  final String id;
  final String title;
 final String content;
 final String image;

  @override
  Widget build(BuildContext context) {
    var isbookmark = false.obs;
    isbookmarkenablecheck()async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String> mList = (pref.getStringList('favoriteList') ?? <String>[]);
      var isbookmarkcheck= mList.contains(id.toString())?true:false;
      if(isbookmarkcheck){
        isbookmark(true);
      }else{
        isbookmark(false);
      }

    }
    isbookmarkenablecheck();


    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
          onTap: (){Get.back();},
          child: const Icon(CupertinoIcons.chevron_back,color: Colors.black,)),
        backgroundColor: Colors.white,elevation: 0,),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8),
              child: Center(
                child: Stack(
                    clipBehavior: Clip.none, fit: StackFit.loose,

                  children: [ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    Imagewid(url: image,height: 200,width:Get.width-20,)
                   ),
                    const SizedBox(height: 50,),
                     Positioned(right: 10,bottom: -20,child: GestureDetector(onTap: (){
                       if (isbookmark == true) {
                         isbookmark(false);
                         removebookmark()async{
                           SharedPreferences prefs = await SharedPreferences.getInstance();
                           var favoriteList = prefs.getStringList('favoriteList')?? [];
                           int index = favoriteList.indexWhere((item) => item.contains(id.toString()));
                           print('index: $index');
                           favoriteList.removeWhere((item) => item == id.toString());
                           prefs.setStringList('favoriteList', favoriteList);

                           var favoriteListData = prefs.getStringList('favoritelistdata')?? [];
                           favoriteListData.removeAt(index);
                           prefs.setStringList('favoritelistdata', favoriteListData);
                         }
                         removebookmark();

                       } else {
                         isbookmark(true);

                         addbookmark()async{
                           SharedPreferences prefs = await SharedPreferences.getInstance();
                           var favoriteList = prefs.getStringList('favoriteList')?? [];
                           favoriteList.add(id.toString());
                           prefs.setStringList('favoriteList', favoriteList);
                           var favoriteListdata = prefs.getStringList('favoritelistdata')?? [];
                           Map<String, dynamic> map = {
                           'title': title,
                           'image':image,
                           'content': content,
                             'docId':id
                           };
                           String rawJson = jsonEncode(map);
                           favoriteListdata.add(rawJson);
                           prefs.setStringList('favoritelistdata', favoriteListdata);
                         }
                         addbookmark();

                       }
                     },
                         child:  Obx(() {
                         return CircleAvatar(child:
                         (isbookmark == false)
                             ?const Icon(CupertinoIcons.bookmark)
                             :const Icon(CupertinoIcons.bookmark_fill),
                    );
})
                    ),

                     )]),
              ),
            ),
           const SizedBox(height: 20,),
           Padding(padding: const EdgeInsets.only(left:10,right:10,bottom: 5),
           child:  Text(title,style: GoogleFonts.mukta(fontSize: 22,fontWeight: FontWeight.bold),),),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: HtmlWidget(content,textStyle: GoogleFonts.notoSerifBengali(fontSize: 18),),

            ),const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
