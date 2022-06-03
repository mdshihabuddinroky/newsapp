import 'package:cloud_firestore/cloud_firestore.dart';
class Post {

  String? docId;
  String? title;
  String? image;
  String? content;
  String? category;
  String? time;
Post({this.docId,this.title,this.image,this.content,this.category,this.time});

Post.fromMap(DocumentSnapshot data){
  docId = data.id;
    title=data["Title"];
    image=data["Image"];
   content=data["Content"];
    category=data["Category"];
 time=data["Time"];

 }


}
