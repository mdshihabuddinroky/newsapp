import 'package:asilation/controller/datacontroller.dart';
import 'package:asilation/view/details.dart';
import 'package:asilation/view/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'addPost.dart';
import 'imagewidget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String>  months  = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    var querry= "".obs;

    final Postcontroller postcontroller = Get.put(Postcontroller());
    postcontroller.getPost();
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 20),
              child: Text(
                'Blog',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Salin',
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: CupertinoSearchTextField(

                placeholder: 'Search Blogs',
                onTap: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.to(const SearchPage());
                },
                onChanged: (search){
                 // querry(search);


                },
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => PaginateFirestore(
              // Use SliverAppBar in header to make it sticky
              //header: const SliverToBoxAdapter(child: Text('HEADER')),
            //  footer: const SliverToBoxAdapter(child: Text('FOOTER')),
              // item builder type is compulsory.
              itemBuilderType:
              PaginateBuilderType.listView,shrinkWrap: true,  physics: const ClampingScrollPhysics(),//Change types accordingly
              itemBuilder: (context, documentSnapshots, index) {

                final data = documentSnapshots[index].data() as Map?;
                var date =
                               DateTime.fromMillisecondsSinceEpoch( int.parse(data!['Time'])) ;
                return  GestureDetector(
                                 onTap: (){
                                  Get.to( Details(id:documentSnapshots[index].id,title: data['Title'],image: data['Image'],content: data['Content'],));
                                 },
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(children: [
                                     ClipRRect(
                                         borderRadius: BorderRadius.circular(10),
                                         child:
                                         Imagewid(url:data['Image'],height: 90,width:120)

                                     ),
                const SizedBox(width: 5,),
                                     Flexible(
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(data['Title'], overflow: TextOverflow.ellipsis,maxLines: 2, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold,fontSize: 18,),),
                                           Text(
                                               "${date.day} ${months[date.month].toString()} ${date.year}",style: GoogleFonts.notoSerif(color: Colors.grey,fontSize: 14),),
                                         ],
                                       ),
                                     ),


                                   ],),
                                 ),
                );
              },
              // orderBy is compulsory to enable pagination
              query: (querry.isEmpty)?FirebaseFirestore.instance.collection('Posts').orderBy('Time',descending: true):
              FirebaseFirestore.instance.collection('Posts').where("Title",isLessThanOrEqualTo: querry.value),
              itemsPerPage: 5,

              isLive: true,
            )

       //          ? ListView.builder(
       //              shrinkWrap: true,
       //        physics: const ClampingScrollPhysics(),
       //             // physics: const AlwaysScrollableScrollPhysics() ,
       //
       //              itemCount: postcontroller.postlist.length,
       //              itemBuilder: (context, index) {
       //                var date =
       //                DateTime.fromMillisecondsSinceEpoch( int.parse(postcontroller.postlist[index].time!)) ;
       //                return GestureDetector(
       //                  onTap: (){
       //                   Get.to( Details(id:postcontroller.postlist[index].docId!,title: postcontroller.postlist[index].title!,image: postcontroller.postlist[index].image!,content: postcontroller.postlist[index].content!,));
       //                  },
       //                  child: Padding(
       //                    padding: const EdgeInsets.all(8.0),
       //                    child: Row(children: [
       //                      ClipRRect(
       //                          borderRadius: BorderRadius.circular(10),
       //                          child:
       //                          Imagewid(url: postcontroller.postlist[index].image!,height: 90,width:120)
       //
       //                      ),
       // const SizedBox(width: 5,),
       //                      Flexible(
       //                        child: Column(
       //                          mainAxisAlignment: MainAxisAlignment.start,
       //                          crossAxisAlignment: CrossAxisAlignment.start,
       //                          children: [
       //                            Text(postcontroller.postlist[index].title!, overflow: TextOverflow.ellipsis,maxLines: 2, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold,fontSize: 18,),),
       //                            Text(
       //                                "${date.day} ${months[date.month].toString()} ${date.year}",style: GoogleFonts.notoSerif(color: Colors.grey,fontSize: 14),),
       //                          ],
       //                        ),
       //                      ),
       //
       //
       //                    ],),
       //                  ),
       //                );
       //              },
       //            )
               )
          ],
        ),
      ),
    );
  }
}
