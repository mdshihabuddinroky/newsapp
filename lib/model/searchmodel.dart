import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  String? docId;
  String? title;
  String? image;
  String? content;
  String? category;
  // String? time;
  DataModel({this.docId,this.title,this.image,this.content,this.category});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          docId: snapshot.id,
          title: dataMap['Title'],
          image: dataMap['Image'],
          content: dataMap['Content'],
          category: dataMap['Category']);
    }).toList();
  }
}