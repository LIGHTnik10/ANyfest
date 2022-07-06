// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:core';
import 'package:anyfest/model/user_model.dart';
import 'package:anyfest/screens/Join_event/my_event.dart';

import 'package:anyfest/screens/edit_profile.dart';
import 'package:anyfest/screens/event_created/user_created_event.dart';
import 'package:anyfest/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'Join_event/join_event.dart';
import 'QR CODE/showqrcode.dart';
import 'chats/one_one_message.dart';
import 'login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final TextEditingController _bioController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          foregroundColor: Colors.black,
          elevation: 5,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        // ignore: prefer_const_constructors
                        MaterialPageRoute(builder: (context) => Setting()));
                  },
                  child: const Icon(
                    Icons.settings_outlined,
                    size: 30,
                  ),
                ))
          ]),
      //<------------------------------------------------------MAIN BODY-------------------------------------------------------->
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //<----------------------------------------------------PROFILE IMAGE---------------------------------------------------------->
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Center(
                            child: SizedBox(
                                height: 150,
                                width: 150,
                                child: Stack(
                                  fit: StackFit.expand,
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            // ignore: prefer_const_constructors
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfile()));
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '${loggedInUser.photoUrl}'),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
//<--------------------------------------------------------USER NAME------------------------------------------------------>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text("${loggedInUser.firstName}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400)),
                                ),
                              )
                            ],
                          ),
//<-----------------------------------------------------USER EMAIL--------------------------------------------------------->
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              const SizedBox(),
                              Text("${loggedInUser.email}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w100))
                            ],
                          ),
//<-------------------------------------------------------USER BIO------------------------------------------------------->

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              readOnly: true,
                              maxLines: 5,
                              controller: _bioController
                                ..text = '${loggedInUser.Bio}',
                              decoration: const InputDecoration(
                                labelText: "Bio",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

//<--------------------------------------------EVENTS------------------------------------------------------------------>

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Events",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
//<----------------------------------------------------------EVENT CREATED---------------------------------------------------->

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserEvents()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("CREATED EVENT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  const SizedBox(width: 95),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

//<-------------------------------------------------------USER JOINED EVENTS------------------------------------------------------->

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EventJoinedUser()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("USER JOINED EVENT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  const SizedBox(width: 50),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
//<-----------------------------------------------------MY JOINED EVENTS--------------------------------------------------------->

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyEvent()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("MY JOINED EVENT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  const SizedBox(width: 75),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //<-----------------------------------------------------QR CODE--------------------------------------------------------->

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ShowQr()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("QR CODE",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  const SizedBox(width: 180),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

//----------------------------------------------------------------//Logout------------------------------------------------------------>
                  Column(
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          logout(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout_outlined,
                              color: Colors.black,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 1.0),
                              child: Text("Logout",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//<--------------------------------------------//LOGOUT FUNCTION FIREBASE------------------------------------------------------------------>

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Loginscreen())); // It worked for me instead of above line
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Loginscreen()));
    setState(() {});
  }
}
