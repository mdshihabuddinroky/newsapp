import 'package:asilation/model/postmodel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class Postcontroller extends GetxController {
  var postlist = <Post>[].obs;



  @override
  void onInit() {
    super.onInit();
    postlist.bindStream(getPost());
  }

  Stream<List<Post>> getPost() =>

      FirebaseFirestore.instance
          .collection('Posts').orderBy('Time',descending: true).snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromMap(doc)).toList());




}