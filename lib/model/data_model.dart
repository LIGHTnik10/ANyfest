// ignore_for_file: avoid_print

import 'package:anyfest/model/event_model.dart';
import 'package:anyfest/model/join_event_model.dart';
import 'package:anyfest/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void onReady() {
    super.onReady();
    userData();
    allData();
  }

//<------------------------------------------------------SHOWING ALL USER EVENTS-------------------------------------------------------->

  List<EventAdd> allEvent = [];
  Future<void> allData() async {
    allEvent = [];
    try {
      const CircularProgressIndicator();
      final List<EventAdd> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('Event')
          .where('uid', isNotEqualTo: user!.uid)
          .get();

      if (response.docs.isNotEmpty) {
        for (var result in response.docs) {
          print(result.data());

          //print("Product ID  ${user!.uid}");
          lodadedProduct.add(EventAdd(
            eventId: result.id,
            uid: result['uid'],
            eventTitle: result['eventTitle'],
            eventImage: result['eventImage'],
            description: result['description'],
            mapAddress: result['mapAddress'],
            longitude: result['longitude'],
            latitude: result['latitude'],
            email: result['email'],
            creatorName: result['creatorName'],
            date: result['date'].toString(),
            time: result['time'].toString(),
          ));
        }
      }
      allEvent.addAll(lodadedProduct);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

//<------------------------------------------------// TO SHOW USER EVENTS-------------------------------------------------------------->

  List<EventAdd> userevent = [];
  Future<void> userData() async {
    userevent = [];
    try {
      const CircularProgressIndicator();
      final List<EventAdd> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('Event')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (response.docs.isNotEmpty) {
        for (var result in response.docs) {
          //print(result.data());

          // print("Product ID  ${user!.uid}");
          lodadedProduct.add(
            EventAdd(
                eventId: result.id,
                uid: result['uid'],
                eventTitle: result['eventTitle'],
                eventImage: result['eventImage'],
                description: result['description'],
                date: result['date'].toString(),
                time: result['time'].toString()),
          );
        }
      }
      userevent.addAll(lodadedProduct);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

//<-----------------------------------------------------//DELETE THE USER CREATED ONLY BY RESPECTED USER.--------------------------------------------------------->
  Future deleteEvent(String eventId) async {
    const CircularProgressIndicator();
    await FirebaseFirestore.instance
        .collection("Event")
        .doc(eventId)
        .delete()
        .then((_) {
      // CommanDialog.hideLoading();
      userData();
    });
  }

  Future deleteUserEvent(String eventId) async {
    const CircularProgressIndicator();
    await FirebaseFirestore.instance.collection("Joins").doc(eventId).delete();
  }

//<----------------------------------------------------------------getting joined user data-------------------------------------------->//
  // ignore: non_constant_identifier_names
  /* Future JoinedUser(String eventId, eventTitle) async {
    Map<String, dynamic> data;
    print(
        "===========================================================================================================");
    print("Product =>>> $eventId ===>  EventTitle:  $eventTitle    ");
    try {
      final List<Join> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('Joins')
          .where('docId', isEqualTo: user!.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (response.docs.isNotEmpty) {
        for (var result in response.docs) {
          print(
              "=======================================================================================================================");
          //print(result.data());
          data = result.data();

          print("${data}");
          print(
              "==============================================================================================");
          print("Product =>>> $eventId ===>  EventTitle:  $eventTitle    ");
          // print("Product ID > ${user!.uid}");

        }
      }
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }*/

//<--------------------------------------------------//EDIT PRODUCT------------------------------------------------------------>

  /* Future editProduct(productId, eventTitle) async {
    print("Product Id  $productId");
    try {
      // CommanDialog.showLoading();
      await FirebaseFirestore.instance
          .collection("Event")
          .doc(productId)
          .update({"product_price": eventTitle}).then((_) {
        // CommanDialog.hideLoading();
        userData();
      });
    } catch (error) {
      // CommanDialog.hideLoading();
      //CommanDialog.showErrorDialog();

      print(error);
    }
  }*/

//-------------------------------------------------------------------//
  EventAdd eventModel = EventAdd();
  Join joinModel = Join();
  List<Join> extrenalJoined = [];
  Future<void> externalJoin([String? eventId]) async {
    extrenalJoined = [];
    try {
      const CircularProgressIndicator();
      final List<Join> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('Joins')
          .where('docId', isEqualTo: user!.uid)
          //.where('eventTitle', isEqualTo: joinModel.eventTitle)
          .get();

      if (response.docs.isNotEmpty) {
        for (var result in response.docs) {
          //print(result.data());

          // print("Product ID > ${user!.uid}");
          lodadedProduct.add(
            Join(
              eventId: result.id,
              uid: result['uid'],
              name: result['name'],
              age: result['age'],
              email: result['email'],
              eventImage: result['eventImage'],
              eventTitle: result['eventTitle'],
              time: result['time'],
              description: result['description'],
              date: result['date'],
            ),
          );
        }
      }
      extrenalJoined.addAll(lodadedProduct);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

//----------------------------JOINED USERS DIALOG--------------------------------//
  List<Join> joiners = [];

  Future<void> joinedUser(String eventId, eventTitle) async {
    joiners = [];
    // String data;
    // print(
    // "===========================================================================================================");
    // print("Product =>>> $eventId ===>  EventTitle:  $eventTitle    ");
    try {
      const CircularProgressIndicator();
      final List<Join> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('Joins')
          .where('docId', isEqualTo: user!.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (response.docs.isNotEmpty) {
        for (var result in response.docs) {
          lodadedProduct.add(
            Join(
              eventId: result.id,
              uid: result['uid'],
              name: result['name'],
              age: result['age'],
              email: result['email'],
              eventImage: result['eventImage'],
              eventTitle: result['eventTitle'],
              time: result['time'],
              description: result['description'],
              date: result['date'],
            ),
          );
        }
        joiners.addAll(lodadedProduct);
        update();
      }
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }
  //---------------------USER JOINED EVENTS----------------//

  List<Join> myevent = [];
  Future<void> myEvent([String? eventId]) async {
    myevent = [];
    try {
      const CircularProgressIndicator();
      final List<Join> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection("Joins")
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (response.docs.isNotEmpty) {
        for (var result in response.docs) {
          // print(result.data());

          //  print("Product ID > ${user!.uid}");
          lodadedProduct.add(
            Join(
                eventId: result.id,
                uid: result['uid'],
                name: result['name'],
                age: result['age'],
                email: result['email'],
                eventImage: result['eventImage'],
                eventTitle: result['eventTitle'],
                eventaddress: result['eventaddress'],
                latitude: result['latitude'],
                longitude: result['longitude'],
                time: result['time'],
                description: result['description'],
                date: result['date'],
                creatorName: result['creatorName'],
                creatorEmail: result['creatorEmail']),
          );
        }
      }
      myevent.addAll(lodadedProduct);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

  //<-----------------------------------------------------//LEAVE EVENT ONLY BY RESPECTED USER.--------------------------------------------------------->

  Future leaveEvent(String eventId) async {
    print("Product =>>> $eventId");
    try {
      const CircularProgressIndicator();
      await FirebaseFirestore.instance
          .collection("Joins")
          .doc(eventId)
          .delete()
          .then((_) {
        // CommanDialog.hideLoading();
        myEvent();
      });
    } catch (error) {
      //CommanDialog.hideLoading();
      //CommanDialog.showErrorDialog();
      print(error);
    }
  } //<-----------------------------------------------------//REMOVE THE USER CREATED ONLY BY RESPECTED EVENTUSER.--------------------------------------------------------->

  Future removeUser(String eventId) async {
    const CircularProgressIndicator();
    await FirebaseFirestore.instance
        .collection("Joins")
        .doc(eventId)
        .delete()
        .then((_) {
      // CommanDialog.hideLoading();
      externalJoin();
    });
  }
}
