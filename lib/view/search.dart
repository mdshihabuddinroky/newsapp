
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/searchmodel.dart';
import 'details.dart';
import 'package:get/get.dart';

import 'imagewidget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FirestoreSearchScaffold(
      appBarBackgroundColor: Colors.red,

      limitOfRetrievedData: 20,
      clearSearchButtonColor: Colors.black,
      backButtonColor: Colors.red,
      firestoreCollectionName: 'Posts',
      searchBy: 'Title',
      scaffoldBody: const Center(),
      appBarTitle: 'Search',
      dataListFromSnapshot: DataModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DataModel>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final DataModel data = dataList[index];


                return GestureDetector(
                  onTap: (){
                    Get.to( Details(id:data.docId!,title: data.title!,image:data.image!,content: data.content!,));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:Imagewid(url: data.image!,height: 90,width:120)

                        ,),
                      const SizedBox(width: 10,)
                      , Flexible(child: Text(data.title!,overflow: TextOverflow.ellipsis,maxLines: 2,style: GoogleFonts.dmSans(fontWeight: FontWeight.bold,fontSize: 20),))
                    ],),
                  ),
                );


                //   Column(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         '${data.title}',
                //         style: Theme.of(context).textTheme.headline6,
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(
                //           bottom: 8.0, left: 8.0, right: 8.0),
                //       child: Text('${data.image}',
                //           style: Theme.of(context).textTheme.bodyText1),
                //     )
                //   ],
                // );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
