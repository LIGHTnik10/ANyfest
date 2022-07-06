// ignore_for_file: avoid_print

import 'package:anyfest/model/data_model.dart';
import 'package:anyfest/model/user_model.dart';
import 'package:anyfest/screens/chats/one_one_message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class UserEvents extends StatefulWidget {
  const UserEvents({Key? key}) : super(key: key);

  @override
  _UserEventsState createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  //<----------------------------------------------------GETTING CONTROLLER ALL DATA FROM DATA MODEL THROUGH DATA CONTROLLER---------------------------------------------------------->
  final DataController controller = Get.put(DataController());
  String eventdate = "";
  String eventtime = "";
  final TextEditingController eventDate = TextEditingController();
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventTime = TextEditingController();
  final TextEditingController joinAge = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.userData();
    });

    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        title: const Text("User Created Events"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 5,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GetBuilder<DataController>(
          builder: (controller) => controller.userevent.isEmpty
              ? const Center(
                  child: Text('😔 NO EVENT CREATED 😔'),
                )
              : ListView.builder(
                  itemCount: controller.userevent.length,
                  itemBuilder: (context, index) {
                    //=================================================================================================================================//
                    showDialogfunc(context) {
                      return showDialog(
                          context: context,
                          builder: (_) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                          child: Text(
                                        "DO YOU WANT TO DELETE THE EVENT: ${controller.userevent[index].eventTitle}  ?",
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: () {
                                                controller.deleteEvent(
                                                  "${controller.userevent[index].eventId}",
                                                );
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "EVENT '${controller.userevent[index].eventTitle}' DELETED SUCESSFULLY",
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              },
                                              child: const Text("Delete")),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  height: 200,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          });
                    }

                    //=================================================================================================================================//
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.lightGreen.shade200,
                        elevation: 10,
                        child: Column(
                          children: [
                            //<------------------------------------------------------CONTAINER FOR SHOWING EVENT IMAGE-------------------------------------------------------->
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Image.network(
                                  '${controller.userevent[index].eventImage}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //<-------------------------------------------------------------SHOWING EVENT NAME------------------------------------------------->
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Event Name: ${controller.userevent[index].eventTitle}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //<-------------------------------------------------------------SHOWING EVENT DATE------------------------------------------------->
                                  Text(
                                    'Date: ${controller.userevent[index].date}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //<-------------------------------------------------------------SHOWING EVENT TIME------------------------------------------------->
                                  Text(
                                    "Time:${controller.userevent[index].time}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            //<--------------------------------------------------------EDIT BUTTON TO EDIT EVENT------------------------------------------------------>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.teal.shade400),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              color: const Color(0xff757575),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20))),
                                                child: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller: eventName
                                                          /*..text =
                                                                    '${controller.userevent[index].eventTitle}'*/
                                                          ,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return ("Enter Event Name");
                                                            }

                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            eventName.text =
                                                                value!;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Event Name",
                                                            hintText:
                                                                " Event Name",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          readOnly: true,
                                                          autofocus: false,
                                                          controller: eventDate
                                                            ..text =
                                                                "${controller.userevent[index].date}",
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return ("Enter Date");
                                                            }

                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            eventDate.text =
                                                                value!;
                                                          },
                                                          onTap: () async {
                                                            await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate:
                                                                  DateTime(
                                                                      2025),
                                                            ).then(
                                                                (selectedDate) {
                                                              if (selectedDate !=
                                                                  null) {
                                                                eventDate.text =
                                                                    eventdate =
                                                                        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                                                              }
                                                            });
                                                          },
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Date",
                                                            hintText: "Date",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          readOnly: true,
                                                          autofocus: false,
                                                          controller: eventTime
                                                            ..text =
                                                                "${controller.userevent[index].time}",
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return ("Enter Date");
                                                            }

                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            eventTime.text =
                                                                value!;
                                                          },
                                                          onTap: () async {
                                                            await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        TimeOfDay
                                                                            .now())
                                                                .then(
                                                                    (selectedTime) {
                                                              if (selectedTime !=
                                                                  null) {
                                                                eventTime.text =
                                                                    eventtime =
                                                                        selectedTime
                                                                            .format(context);
                                                              }
                                                            });
                                                          },
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Date",
                                                            hintText: "Date",
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            updateData(context,
                                                                "${controller.userevent[index].eventId}");
                                                          },
                                                          child: const Text(
                                                              "Update"))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  //<-----------------------------------------------------------JOINED USER BUTTON EVENT--------------------------------------------------->
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.teal.shade400),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              color: const Color(0xff757575),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20))),
                                                child:
                                                    GetBuilder<DataController>(
                                                  builder: (controller) =>
                                                      controller.joiners.isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  '😔 NO USER JOINED  😔'),
                                                            )
                                                          : ListView.builder(
                                                              itemCount:
                                                                  controller
                                                                      .joiners
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                //=================================================================================================================================//

                                                                deleteuser(
                                                                    context) {
                                                                  return showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) {
                                                                        return Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Container(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Center(
                                                                                      child: Text(
                                                                                    "DO YOU WANT TO REMOVE ${controller.joiners[index].name} ?",
                                                                                    style: const TextStyle(fontSize: 20),
                                                                                  )),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(primary: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                            Fluttertoast.showToast(msg: "User ${controller.joiners[index].name} is removed Sucessfully", toastLength: Toast.LENGTH_LONG);
                                                                                            print("Removed User: ${controller.joiners[index].name}");
                                                                                            controller.deleteUserEvent("${controller.joiners[index].eventId}");
                                                                                          },
                                                                                          child: const Text("Remove")),
                                                                                      ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(primary: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: const Text(
                                                                                            "Cancel",
                                                                                            style: TextStyle(color: Colors.black),
                                                                                          )),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              height: 200,
                                                                              width: 350,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(),
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                }

                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Name: ${controller.joiners[index].name}"),
                                                                          Text(
                                                                              "Email: ${controller.joiners[index].email}"),
                                                                          Text(
                                                                              "Age: ${controller.joiners[index].age}"),
                                                                          Text(
                                                                              "Event: ${controller.joiners[index].eventTitle}"),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                deleteuser(context);
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.delete,
                                                                                color: Colors.black,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                ),
                                              ),
                                            );
                                          });
                                      controller.joinedUser(
                                          "${controller.userevent[index].eventId}",
                                          "${controller.userevent[index].eventTitle}");
                                    },
                                    child: const Text('Joined'),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.teal.shade400),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => chatpage(
                                                      email: '${user!.email}',
                                                    )));
                                      },
                                      child: Text("CHATS")),

                                  //-----------------------------------------------------------------------------------------------//
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.teal.shade400),
                                    onPressed: () {
                                      showDialogfunc(
                                        context,
                                      );
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  //<--------------------------------------------------//UPLOAD EVENT IMAGE URL TO FIREBASE FIRESTORE------------------------------------------------------------>

  void updateData(BuildContext context, eventId) async {
//<----------------------------------------------//UPLOADING EVENT DETAILS TO FIREBASE FIRESTORE---------------------------------------------------------------->

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = {};

    map['eventTitle'] = eventName.text;
    map['date'] = eventDate.text;
    map['time'] = eventTime.text;
    if (_formKey.currentState!.validate()) {
      firebaseFirestore.collection("Event").doc(eventId).update(map);

      Navigator.pop(context);

      Fluttertoast.showToast(msg: "Event Updated Sucessfully");
    }
  }

  Future refresh() async {
    setState(() {
      controller.userevent.length;
    });
  }

  final TextEditingController search = TextEditingController();
  bool isLoading = false;
  late Map<String, dynamic> userMap = {};
  void onSearch(String eventId) async {
    setState(() {
      isLoading = false;
    });
    FirebaseFirestore fire = FirebaseFirestore.instance;

    await fire
        .collection("Joins")
        .where("email", isEqualTo: search.text)
        .where('eventId', isEqualTo: eventId)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }
}
