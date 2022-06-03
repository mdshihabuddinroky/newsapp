

import 'package:asilation/view/Category.dart';

import 'package:asilation/view/Favourite.dart';
import 'package:asilation/view/Home.dart';
import 'package:asilation/view/addPost.dart';
import 'package:flutter/cupertino.dart';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
 options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(

        iconTheme: const IconThemeData(color: Colors.black),
          scaffoldBackgroundColor: Colors.white),
      title: 'Firestore pagination library',
      debugShowCheckedModeBanner: false,


      home: HomePage(),
    );
  }
}
var appbaractive = 0.obs;
class HomePage extends StatelessWidget {

  var appbarpage = [const Home(), const CategoryPage(), const Favourite()];

  HomePage({Key? key}) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(() =>
        Scaffold(
            backgroundColor: Colors.white,
            appBar: (appbaractive.value == 0) ? AppBar(

              backgroundColor: Colors.white,
              elevation: 0,
              leading: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Get.to(const AddPage(title: 'Add Post',));
                      },
                      child: const Icon(
                        Icons.note_add_outlined, color: Colors.black,)),
                )
              ],
            ) : (appbaractive.value == 1) ? header(titleText:'Categories') : header(titleText:'Favourite'),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: appbaractive.value,
                iconSize: 0,
                selectedLabelStyle: const TextStyle(
                    fontFamily: 'Salin', fontSize: 18),
                unselectedFontSize: 16,
                selectedItemColor: Colors.black,

                onTap: (index) {
                  appbaractive(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.category_outlined), label: 'Category'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_outline), label: 'Favourite')
                ]),
            body: WillPopScope(
                onWillPop: () async {
                  if (scaffoldKey.currentState?.isDrawerOpen == true) {
                    Navigator.of(context).pop();
                    return false;
                  } else {
                    if (appbaractive.value != 0) {
                      appbaractive(0);
                      return false;
                    } else {
                      return (await showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text('Do you want to exit an App'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => SystemNavigator.pop(),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                      )) ??
                          false;
                    }
                  }
                },
                child: appbarpage[appbaractive.value])
        )
    );
  }}
late final String title;
PreferredSizeWidget header( {required String titleText}){


    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        elevation: 0,
        title:  Text(
          titleText,
          style: const TextStyle(fontFamily: 'Salin', color: Colors.black),
        ),
        leading:  GestureDetector(child: const Icon(CupertinoIcons.back, color: Colors.black),onTap:(){appbaractive(0);

        }),
        backgroundColor: Colors.white,
      ),
    );
  }


