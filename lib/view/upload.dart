import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase/provider/passwordvisibility.dart';
import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/UploadImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class Upload extends StatefulWidget {
  Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File? file;
  XFile?
      image; // yeslai ya define garesi matra 2nd function ma access garna paiyo natra image lai first function ma chinxa
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<Passwordvisibility>(builder: (context, passwordVisibility, child) => 
             Stack(children: [
                  ui(),
                  loader
              ? Center(child: CircularProgressIndicator())
              : SizedBox() //loader? ra loader==true? aautei ho
          //yedi loader ko value true aaye matra circular progress indicator dekhaune
                ]),
          )),
    );
  }

  pickImageFromGallery(Passwordvisibility passwordVisibility) async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    image = await picker.pickImage(source: ImageSource.gallery);
    //or image =await ImagePicker().pickImage
    //picker ko replace ma direct ImagePicker() lina paiyo
    //ImagePicker matra vanya class vayo ,ra ImagePicker() vanya ob vayo
    //image select vayesi image vanne variable ma basxa
    //   print(image);
    if (image == null)
      return; //If image is null, the function returns early and does not proceed further, avoiding any potential errors due to null references.
    //image null vaye return vanda muni ko code chaldaina aaba
    file = File(image!.path);
   passwordVisibility.selectedfile(file);
   passwordVisibility.selectedfile(image);
  }

  UploadImageToFirebase() async {
    setState(() {
      loader = true;
    });
    final storageRef = FirebaseStorage.instance.ref();
    var uploadValue = storageRef.child(image!
        .name); //image lai mathi ko function ma matra chinxa so teslai mathinai declare gareko yaha acces gareko
    //image ko name liyera uploadvalue ma rakhya
    await uploadValue.putFile(file!);
    final downloadUrl = await storageRef.child(image!.name).getDownloadURL();
    print(downloadUrl);
    // firebase storage  le diyeko download link lai hamile aaba firebase database ma  json format ma store garne
    var data = {"image": downloadUrl};
    await FirebaseFirestore.instance.collection("ImageUrl").add(data).then(
      // then vaneko sucess vaisakesi k garne hamlai loader false garaunu xa ra image ra file null garayesi tya select vayeko image dekhai ui ma rakhdaina
      (value) {
        setState(() {
          loader = false;
          image = null;
          file = null;
        });
      },
    );
  }

  Widget ui() {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                pickImageFromGallery(Passwordvisibility());
                },
                child: DottedBorder(
                  color: colorstr,
                  padding: EdgeInsets.only(left: 50, right: 50, bottom: 30),
                  child: Container(
                      child: file == null
                          ? Column(
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 150,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Text(
                                  "Upload a picture",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            )
                          : Image.file(
                              file!,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ElevatedButton(
                onPressed: () {
                  UploadImageToFirebase();
                },
                style: ElevatedButton.styleFrom(
                    primary: colorstr, onPrimary: Colors.white),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(child: Text("Continue")))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {},
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.google),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Login with Google")
                ],
              ),
            )
            ),
            Row(
              children: [Expanded(
                child: Divider(
              
                  endIndent:10 ,
                  
                          
                ),
              ),
              Text("or"),
              Expanded(
                child: Divider(
              indent: 10,
                ),
              ), Divider()
              ]
            )
      ],
    );
  }
}
