import 'package:anyfest/model/data_model.dart';
import 'package:anyfest/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class EventJoinedUser extends StatefulWidget {
  const EventJoinedUser({Key? key}) : super(key: key);

  @override
  _EventJoinedUserState createState() => _EventJoinedUserState();
}

class _EventJoinedUserState extends State<EventJoinedUser> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final DataController controller = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.externalJoin();
    });
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        title: const Text("Joined User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 5,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: refresh,
            child: GetBuilder<DataController>(
              builder: (controller) => controller.extrenalJoined.isEmpty
                  ? const Center(
                      child: Text('😔 NO USER FOUND 😔'),
                    )
                  : ListView.builder(
                      itemCount: controller.extrenalJoined.length,
                      itemBuilder: (context, index) {
                        controller.extrenalJoined[index].eventId;

                        return Card(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.lightGreen.shade200,
                          elevation: 10,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'EVENT: ${controller.extrenalJoined[index].eventTitle}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              //<-----------------------------------------------------EVENT IMAGE--------------------------------------------------------->

                              const SizedBox(
                                height: 10,
                              ),
                              //<------------------------------------------------------EVENT NAME-------------------------------------------------------->
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //<-------------------------------------------------------EVENT DATE------------------------------------------------------->
                                    Text(
                                      'Name: ${controller.extrenalJoined[index].name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Age: ${controller.extrenalJoined[index].age}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text(
                                      'Email: ${controller.extrenalJoined[index].email}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'UID: ${controller.extrenalJoined[index].uid}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal.shade400),
                                          onPressed: () {
                                            controller.removeUser(
                                              "${controller.extrenalJoined[index].eventId}",
                                            );
                                          },
                                          child: const Text('Remove'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //<-------------------------------------------------------------------------------------------------------------->
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future refresh() async {
    setState(() {
      controller.allEvent.length;
    });
  }
}
