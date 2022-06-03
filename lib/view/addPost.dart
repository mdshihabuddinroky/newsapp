

import 'dart:io';   // for File
import 'package:file_picker/file_picker.dart';



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../controller/categorycontorller.dart';
import 'package:firebase_storage/firebase_storage.dart';



class AddPage extends StatefulWidget {
  const AddPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<AddPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {


    TextEditingController titleController =  TextEditingController();
    final Categorycontroller categorycontroller = Get.put(Categorycontroller());
    final _formKey = GlobalKey<FormState>();

    HtmlEditorController controller = HtmlEditorController();
    var dropdownvalue = ''.obs;



    var items = ["Test","Test1","Test2"].obs;
    File? pickfile;
    var isfileavailable = false.obs;
    UploadTask? uploadTask;
    var ImageUrl=''.obs;


    var filename =''.obs;
    Future uploadfile()async{
      final _firebaseStorage =FirebaseStorage.instance;

      var snapshot = await _firebaseStorage.ref()
          .child(filename.value)
          .putFile(pickfile!).whenComplete(() => (){});
      var downloadUrl = await snapshot.ref.getDownloadURL();
      ImageUrl(downloadUrl);
      Get.back();


    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),

          title: Text(widget.title,style: GoogleFonts.dmSans(color: Colors.black),),elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:  [
                const SizedBox(height: 5,),
                GestureDetector(
                  onTap: ()async{
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowedExtensions: ['jpg', 'png', 'jpeg'],
                      type: FileType.custom,
                      allowMultiple: false,
                    ); //allowedExtensions: ['pdf', 'doc']);
                    if (result != null) {

                      filename("files/${result.files.single.name}");
                    final path = result.files.single.path;
                     pickfile = File(path!);
                    isfileavailable(true);
                      uploadfile();
                      Get.dialog(const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ));

                    }//2 positional argument(s) expected, but 1 found. and The argument type 'String?' can't be assigned to the parameter type 'List<Object>'.


                  },
                  child: Obx(() {
  return Container(
                    height: 180,
                    width: Get.width-20,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black)),
                    child:  Center(
                      child:(!isfileavailable.value)? const Icon(Icons.photo_camera_outlined):
    Image.file(pickfile!,height: 180,
      width: Get.width-20,fit: BoxFit.cover,)
                    ),
                  );
}),),

                const SizedBox(height: 10,),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Title',border: InputBorder.none ,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),

                  ),validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                ),


                const SizedBox(height: 10,),
    Obx(() {

  return (categorycontroller.categorylist.isNotEmpty)? Container(
      height: 50,
        width: Get.width-20,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black)),
      child:
      DropdownButton(

      // Initial Value
      value: (dropdownvalue.value.isEmpty)?categorycontroller.categorylist[0].name:dropdownvalue.value,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),
      onChanged: (String? newValue){

        dropdownvalue(newValue!);
      },


      items: [
        for (int i=0; i< categorycontroller.categorylist.length; i++)
          DropdownMenuItem<String>(
            value:categorycontroller.categorylist[i].name,
            child: Text(
              categorycontroller.categorylist[i].name,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
      ]


      ),
    ): const CircularProgressIndicator(color: Colors.red,);
}),
                 const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black)),
                  child: HtmlEditor(
                    controller: controller, //required
                    htmlEditorOptions: const HtmlEditorOptions(
                        hint: "Enter Content Here..",
                        shouldEnsureVisible: true,autoAdjustHeight: true

                    ),    htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeExpandable, //by default
                    defaultToolbarButtons: const[ StyleButtons(),FontSettingButtons(fontSizeUnit: true),
                      ColorButtons(), ListButtons(listStyles: false),ParagraphButtons(textDirection: false, lineHeight: false, caseConverter: false),InsertButtons(video: true, audio: false, table: false, hr: false, otherFile: false)
                    ],


                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      print(url);
                      return true;
                    },

                  ),
                    otherOptions:  const OtherOptions(

                        decoration:  BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)
                        ),
                            border: Border.fromBorderSide(BorderSide(color: Color(0xffececec), width: 1)
                            )
                        ),

                        height: 300
                    ),
                  ),
                ),
                const SizedBox(height: 5,),ElevatedButton(
                  style:ElevatedButton.styleFrom(primary: Colors.green,padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 5),elevation: 0),
                  onPressed: () async{
                    var txt = await controller.getText();

                    if (_formKey.currentState!.validate() && txt.isEmpty && ImageUrl.value.isNotEmpty) {
                      categorycontroller.addPost(titleController.text, ImageUrl, txt, dropdownvalue.value);
                  // add data
                      controller.clear();
                      controller.clearFocus();
                      _formKey.currentState!.reset();
                      isfileavailable(false);
                      Get.dialog(const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ));

                    }else{
                     Get.snackbar('Failed!', 'Please fill All Details',backgroundColor: Colors.red,snackStyle: SnackStyle.FLOATING);
                    }
                  },
                  child:  Text('Submit',style: GoogleFonts.mukta(fontSize: 20),),
                ), const SizedBox(height: 5,)

              ],
            ),
          )),
        ));


  }
}
