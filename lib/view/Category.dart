import 'package:asilation/controller/categorycontorller.dart';
import 'package:asilation/view/categorypost.dart';
import 'package:asilation/view/imagewidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Categorycontroller categorycontroller = Get.put(Categorycontroller());
    return Scaffold(

        backgroundColor: const Color.fromARGB(153, 235, 231, 231),
        body: Obx(
          () => (categorycontroller.categorylist.value != null)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: categorycontroller.categorylist.length,
                  itemBuilder: (itemBuilder, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: () {
                          categorycontroller.categorylist[index].name;
                          Get.to(Categorypost(
                              categoryname:
                                  categorycontroller.categorylist[index].name));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                                categorycontroller.categorylist[index].name),
                            leading:
                            Imagewid(url: categorycontroller.categorylist[index].image,height: 50,width:50,)

                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
