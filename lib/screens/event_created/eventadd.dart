import 'dart:io';

import 'package:anyfest/model/event_model.dart';
import 'package:anyfest/model/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as locator;

// ignore: camel_case_types
class addnote extends StatefulWidget {
  const addnote({Key? key}) : super(key: key);

  @override
  State<addnote> createState() => _addnoteState();
}

// ignore: camel_case_types
class _addnoteState extends State<addnote> {
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

  String eventdate = "";
  String eventtime = "";

  final _formKey = GlobalKey<FormState>();

  TextEditingController eventTitle = TextEditingController();
  TextEditingController mappped = TextEditingController();

  TextEditingController eventDetails = TextEditingController();

  TextEditingController eventDate = TextEditingController();
  TextEditingController eventTime = TextEditingController();

  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
//<--------------------------------------------//EVENT TITLE------------------------------------------------------------------>

    final title = TextFormField(
      autofocus: false,
      cursorColor: Colors.teal,
      controller: eventTitle,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter Event title");
        }

        return null;
      },
      onSaved: (value) {
        eventTitle.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Title",
        hintText: "Title",
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(),
      ),
    );

    //<--------------------------------------------//MAPS ------------------------------------------------------------------>

    final maps = TextFormField(
      autofocus: false,
      maxLines: 5,
      cursorColor: Colors.teal,
      controller: mappped..text = "$addresslocation",
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("MAPS");
        }
      },
      onSaved: (value) {
        mappped.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "EVENT ADDRESS",
        hintText: "MAPS",
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(),
      ),
    );
//<--------------------------------------------------//ENTER EVENT DETAILS------------------------------------------------------------>

    final details = TextFormField(
      autofocus: false,
      cursorColor: Colors.teal,
      controller: eventDetails,
      maxLength: 50,
      maxLines: 5,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter Event details");
        }

        return null;
      },
      onSaved: (value) {
        eventDetails.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Details",
        hintText: "Details",
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(),
      ),
    );
//<----------------------------------------------------//EVENT DATE---------------------------------------------------------->

    final date = TextFormField(
      readOnly: true,
      cursorColor: Colors.teal,
      controller: eventDate,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter Event date");
        }

        return null;
      },
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2025),
        ).then((selectedDate) {
          if (selectedDate != null) {
            eventDate.text = eventdate =
                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
          }
        });
      },
      decoration: const InputDecoration(
        labelText: "Date",
        hintText: "Date",
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
    //<----------------------------------------------------//EVENT TIME---------------------------------------------------------->

    final time = TextFormField(
      readOnly: true,
      cursorColor: Colors.teal,
      controller: eventTime,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter Event time");
        }

        return null;
      },
      onTap: () async {
        await showTimePicker(context: context, initialTime: TimeOfDay.now())
            .then((selectedTime) {
          if (selectedTime != null) {
            eventTime.text = eventtime = selectedTime.format(context);
          }
        });
      },
      decoration: const InputDecoration(
        labelText: "Time",
        hintText: "Time",
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
//<-----------------------------------------------//CREATING EVENT BUTTON--------------------------------------------------------------->

    final create = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal.shade400),
      onPressed: () {
        insertData(context);
      },
      child: const Text("Save"),
    );
//<-----------------------------------------------//CHOSING IMAGE BUTTON--------------------------------------------------------------->

    final addImage = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal.shade400),
      onPressed: () {
        chooseImage();
      },
      child: const Text("Add Image"),
    );
//<----------------------------------------------// image---------------------------------------------------------------->

    final image = Container(
      height: 200,
      width: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: file == null
          ? OutlinedButton(
              clipBehavior: Clip.none,
              onPressed: () {
                chooseImage();
              },
              child: const Center(
                child: Text("Click Here to Upload Image"),
              ),
            )
          : Image.file(file!),
    );
//<-------------------------------------------------------------------------------------------------------------->
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create event"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 5,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
//<----------------------------------------MAIN BODY STARTS---------------------------------------------------------------------->
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    image,
                    const SizedBox(height: 10),
                    addImage,
                    const SizedBox(height: 10),
                    title,
                    const SizedBox(height: 10),
                    details,
                    const SizedBox(height: 10),
                    date,
                    const SizedBox(height: 10),
                    time,
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      height: 500,
                      child: Stack(
                        children: [
                          GoogleMap(
                            rotateGesturesEnabled: true,
                            onTap: (tapped) async {
                              Address address = await geoCode.reverseGeocoding(
                                  latitude: tapped.latitude,
                                  longitude: tapped.longitude);
                              getMarkers(tapped.latitude, tapped.longitude);
                              /* await FirebaseFirestore.instance
                                  .collection("Location")
                                  .add({
                                'latitude': tapped.latitude,
                                'longtitude': tapped.longitude,
                                'Address': address.streetAddress,
                                'postalcode': address.postal,
                                'city': address.city,
                                'region': address.region,
                                'streetNumber': address.streetNumber,
                              });*/
                              setState(() {
                                city = address.city;
                                addresslocation = address.streetAddress;
                                latitude = "${tapped.latitude}";
                                longitude = "${tapped.longitude}";
                              });
                            },
                            initialCameraPosition: const CameraPosition(
                                target: LatLng(
                                    19.09889157004121, 72.85163327432217),
                                zoom: 10),
                            myLocationButtonEnabled: true,
                            mapType: MapType.hybrid,
                            compassEnabled: true,
                            myLocationEnabled: false,
                            markers: markers,
                            onMapCreated: (GoogleMapController controller) {
                              setState(() {
                                googleMapController = controller;
                              });
                            },
                            mapToolbarEnabled: true,
                            scrollGesturesEnabled: true,
                          ),
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Enter Address",
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: search,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      searchAdd = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          /* Positioned(
                            bottom: 50,
                            child: Text(
                              "$addresslocation",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),*/
                          Positioned(
                            bottom: 20,
                            right: 55,
                            child: FloatingActionButton(
                              child: const Icon(
                                Icons.location_searching,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                getLocation();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    maps,
                    /*ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GoogleMaps()));
                        },
                        child: const Text("Tap to add Address of Event ")),*/
                    const SizedBox(height: 10),
                    create,
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//<--------------------------------------------//CHOOSE EVENT IMAGE------------------------------------------------------------------>

  File? file;
  void chooseImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    setState(() {});
  }

//<--------------------------------------------------//UPLOAD EVENT IMAGE URL TO FIREBASE FIRESTORE------------------------------------------------------------>

  void insertData(BuildContext context) async {
    Map<String, dynamic> map = {};
    if (file != null) {
      String url = await uploadImage();
      map['eventImage'] = url;
      map['email'] = loggedInUser.email;
      map['creatorName'] = loggedInUser.firstName;
    }
//<----------------------------------------------//UPLOADING EVENT DETAILS TO FIREBASE FIRESTORE---------------------------------------------------------------->

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final docId = firebaseFirestore.collection('Event').doc().id;
    EventAdd eventModel = EventAdd();
    eventModel.date = eventdate;
    eventModel.time = eventtime;
    eventModel.description = eventDetails.text;
    eventModel.eventTitle = eventTitle.text;
    eventModel.eventImage = map['eventImage'];
    eventModel.uid = user!.uid;
    eventModel.eventId = docId;
    eventModel.docId = user!.uid;
    eventModel.email = map['email'];
    eventModel.creatorName = map['creatorName'];

    //==============================================//

    eventModel.mapAddress = mappped.text;
    eventModel.latitude = "$latitude";
    eventModel.longitude = "$longitude";
    //==============================================//
    if (_formKey.currentState!.validate()) {
      firebaseFirestore
          .collection("Event")
          .doc(eventModel.eventId)
          .set(eventModel.toMap());
      Navigator.pop(
        context,
      );
      Fluttertoast.showToast(msg: "Event Created Sucessfully");
    }
  }

//<-----------------------------------------------//UPLOADING IMAGE TO FIREBASE STORAGE--------------------------------------------------------------->

  Future uploadImage() async {
    final postID = DateTime.now();
    toString();
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("${loggedInUser.email}" "/EventImage")
        .child("$postID")
        .putFile(file!);
    return taskSnapshot.ref.getDownloadURL();
  }
  //=====================================//

  GeoCode geoCode = GeoCode();
  late GoogleMapController googleMapController;
  //==================================================================//
  Set<Marker> markers = {};
  late Position position;
  //==================================================================//
  void getMarkers(double lat, double long) {
    markers.isEmpty ? markers : markers.clear();
    var markerId = MarkerId(lat.toString() + long.toString());
    var marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor
          .defaultMarker, /*infoWindow: InfoWindow(title: '$addresslocation')*/
    );
    setState(() {
      markers.add(marker);
    });
  }

  //==================================================================//
  void getCurrentPosition() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  void initstate() {
    super.initState();
    getCurrentPosition();
  }

//==========================================CurrentLocation=======================================//
  Location currentLocation = Location();
  void getLocation() async {
    currentLocation.onLocationChanged.listen((LocationData loc) {
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 18.0,
      )));

      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
          ),
        );
      });
    });
  }

//==========================================================================//
  String? city;
  String? addresslocation;
  String? latitude;
  String? longitude;

  //=============================SEARCHING IN MAP=====================================//
  late String searchAdd;
  void search() {
    locator.locationFromAddress(searchAdd).then((result) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(result[0].latitude, result[0].longitude),
              zoom: 18),
        ),
      );
    });
  }
}
