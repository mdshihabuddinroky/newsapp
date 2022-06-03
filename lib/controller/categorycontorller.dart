import 'package:asilation/model/categorymodel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class Categorycontroller extends GetxController {
  var categorylist = <Category>[].obs;
  var dropdownvalue=''.obs;

  @override
  void onInit() {
    super.onInit();
    categorylist.bindStream(getCategory());
  }

    Stream<List<Category>> getCategory() => FirebaseFirestore.instance
      .collection('Categories')
      .orderBy('name', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

  addPost(String title,image,content,category){

    FirebaseFirestore.instance
        .collection('Posts').add({
      'Title': title,
      'Image': image.toString(),
      'Content': content.toString(),
      'Category': category.toString(),
      'Time':DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value){ print("Updated");
    Get.back();
    Get.snackbar('Success', 'Successfully post added');}
    )
        .catchError((error) {

    print("Failed");Get.back();
    Get.snackbar('Success', 'Successfully post added');});
  }
}
