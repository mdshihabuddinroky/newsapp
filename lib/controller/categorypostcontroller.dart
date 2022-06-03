import 'package:asilation/model/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';

class CategoryPostcontroller extends GetxController {
  @required
  final categoryname;

  var postlist = <Post>[].obs;

  CategoryPostcontroller(this.categoryname);

  @override
  void onInit() {
    super.onInit();
    postlist.bindStream(getPost());
  }

  Stream<List<Post>> getPost() => FirebaseFirestore.instance
      .collection('Posts')
      .orderBy('Title')
      .where('Category', isEqualTo: categoryname)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromMap(doc)).toList());
}
