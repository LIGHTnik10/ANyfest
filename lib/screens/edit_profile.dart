import 'dart:io';

import 'package:anyfest/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? downloadURL;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        title: const Text(
          "Edit-Profile",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      //<--------------------------------------------------------MAIN BODY------------------------------------------------------>
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        //<-------------------------------------------------------IMAGE CONTAINER------------------------------------------------------->
                        child: SizedBox(
                            height: 105,
                            width: 105,
                            child: Stack(
                              fit: StackFit.expand,
                              clipBehavior: Clip.none,
                              children: [
                                file == null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '${loggedInUser.photoUrl}'),
                                      )
                                    : Image.file(file!),
                                Positioned(
                                  right: -20,
                                  bottom: 0,
                                  child: SizedBox(
                                    child: OutlinedButton(
                                        style: TextButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: Colors.white),
                                        onPressed: () {
                                          chooseImage();
                                        },
                                        child: Image.asset(
                                          'assets/images/camera.png',
                                          width: 38,
                                          height: 38,
                                        )),
                                  ),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //<-------------------------------------------------------EDITING NAME FIELD------------------------------------------------------->
                      TextField(
                        controller: _textEditingController
                          ..text = '${loggedInUser.firstName}',
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                            labelText: "Name",
                            hintText: "Enter name",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //<------------------------------------------------------EDITING BIO FIELD-------------------------------------------------------->
                      TextField(
                        maxLines: 8,
                        maxLength: 50,
                        controller: _bioController
                          ..text = '${loggedInUser.Bio}',
                        decoration: const InputDecoration(
                            labelText: "BIO",
                            hintText: "Bio",
                            border: OutlineInputBorder()),
                      ),
                      //<---------------------------------------------------------//UPDATE BUTTON----------------------------------------------------->

                      ElevatedButton(
                        onPressed: () {
                          updateProfile(context);
                        },
                        child: const Text("Update"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//<----------------------------------------------------//CHOOSE IMAGE FROM YOUR STORAGE---------------------------------------------------------->

  void chooseImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    setState(() {});
  }

//<--------------------------------------------------------//UPDATING USER PROFLE IN FIRESTORE------------------------------------------------------>

  Future updateProfile(BuildContext context) async {
    // ignore: prefer_collection_literals

    Fluttertoast.showToast(msg: "Updated Sucessfully");
    Map<String, dynamic> map = {};
    if (file != null) {
      String url = await uploadImage();
      map['photoUrl'] = url;
    }
    map['firstName'] = _textEditingController.text;
    map['bio'] = _bioController.text;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(map);
    Navigator.pop(context);
  }

//<------------------------------------------------------//UPLOADING IMAGE TO FIREBASE STORAGE-------------------------------------------------------->

  Future uploadImage() async {
    final postID = DateTime.now();
    toString();
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("${loggedInUser.email}" "/Profile")
        .child("$postID")
        .putFile(file!);
    return taskSnapshot.ref.getDownloadURL();
  }
}
