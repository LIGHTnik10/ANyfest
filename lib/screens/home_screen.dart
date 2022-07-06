// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:anyfest/model/data_model.dart';

import 'package:anyfest/model/join_event_model.dart';

import 'package:anyfest/model/user_model.dart';

import 'package:anyfest/screens/event_created/eventadd.dart';

import 'package:anyfest/screens/profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final DataController controller = Get.put(DataController());
  final TextEditingController joinName = TextEditingController();
  final TextEditingController joinEmail = TextEditingController();
  final TextEditingController joinAge = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        controller.allEvent.length;
      });
    });
  }

  GeoCode geoCode = GeoCode();
  late GoogleMapController googleMapController;
  //==================================================================//
  Set<Marker> markers = {};
  late Position position;
  //==================================================================//
  /* void getMarkers(double lat, double long) {
    markers.isEmpty ? markers : markers.clear();
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(snippet: '$addresslocation'));
    setState(() {
      markers[markerId] = marker;
    });
  }*/

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
    controller.allEvent.length;
  }

//==========================================================================//
  String? city;
  String? addresslocation;

  //==================================================================//
//<----------------------------------------------------GETTING CONTROLLER ALL DATA FROM DATA MODEL THROUGH DATA CONTROLLER---------------------------------------------------------->

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.allData();
    });
//---------------------------------------------------------------------------------------------------------------------------------//
    final name = TextFormField(
      readOnly: true,
      autofocus: false,
      cursorColor: Colors.teal,
      controller: joinName..text = "${loggedInUser.firstName}",
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter Name");
        }

        return null;
      },
      onSaved: (value) {
        joinName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Name",
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(),
      ),
    );
//-------------------------------------------------------------------------------------------------------//
    final email = TextFormField(
      readOnly: true,
      autofocus: false,
      cursorColor: Colors.teal,
      controller: joinEmail..text = "${loggedInUser.email}",
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter Email");
        }

        return null;
      },
      onSaved: (value) {
        joinName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Email",
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(),
      ),
    );
//-----------------------------------------------------------------------------------------------------------//
    final age = TextFormField(
      autofocus: false,
      controller: joinAge,
      cursorColor: Colors.teal,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your AGE");
        }
        //reg expression for email validation
        if (!RegExp(r"^[0-9]{2}$").hasMatch(value)) {
          return ("Please Enter a valid Age");
        }
        return null;
      },
      onSaved: (value) {
        joinName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Age",
        hintText: "Enter Age",
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        border: OutlineInputBorder(),
      ),
    );

//-----------------------------------------------------------------------------------------//
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.green.shade900,
          child: const Icon(
            Icons.add,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const addnote()));
          }),
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
          title: const Text(
            "DashBoard",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 5,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${loggedInUser.photoUrl}"),
                            ),
                          ],
                        ),
                        height: 50,
                        width: 50,
                      ),
                    )))
          ]),
//<----------------------------------------------------MAIN BODY---------------------------------------------------------->
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GetBuilder<DataController>(
          builder: (controller) => controller.allEvent.isEmpty
              ? const Center(
                  child: Text('😔 NO EVENT FOUND 😔'),
                )
              : ListView.builder(
                  itemCount: controller.allEvent.length,
                  itemBuilder: (context, index) {
                    //==========================================================joinEvent==========================================//

                    Future joinEvent(
                        eventId,
                        eventTitle,
                        date,
                        description,
                        time,
                        eventImage,
                        uid,
                        latitude,
                        longitude,
                        mapAddress,
                        creatorName,
                        creatorEmail) async {
                      Join joinModel = Join();
                      joinModel.email = joinEmail.text;
                      joinModel.name = joinName.text;
                      joinModel.uid = loggedInUser.uid;
                      joinModel.age = joinAge.text;

                      //--------------------------------------------//
                      joinModel.eventId = eventId;
                      joinModel.eventTitle = eventTitle;
                      joinModel.date = date;
                      joinModel.description = description;
                      joinModel.time = time;
                      joinModel.eventImage = eventImage;
                      joinModel.docId = uid;
                      joinModel.creatorName = creatorName;
                      joinModel.creatorEmail = creatorEmail;
                      //============================================//
                      joinModel.latitude = latitude;
                      joinModel.longitude = longitude;
                      joinModel.eventaddress = mapAddress;
                      //============================================//
                      print("Product => $eventId");

                      const CircularProgressIndicator();
                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance
                            // .collection("Event")
                            // .doc(eventId)
                            .collection("Joins")
                            .doc()
                            .set(joinModel.toMap());
                        Navigator.pop(
                          context,
                        );
                        Fluttertoast.showToast(
                            msg:
                                "Event ${controller.allEvent[index].eventTitle} Joined Sucessfully");
                      }
                    }

                    //============================================================================================================================================//

                    //--------------------------------------------------------------------------------------------------------------------------------------------//
                    showDialogfunc(
                        context,
                        eventImage,
                        eventTitle,
                        date,
                        time,
                        description,
                        latitude,
                        longitude,
                        mapAddress,
                        creatorName) {
                      var latlong =
                          "${controller.allEvent[index].latitude},${controller.allEvent[index].longitude}"
                              .split(",");
                      var address = "${controller.allEvent[index].mapAddress}";
                      print(address);
                      launchMaps() {
                        MapsLauncher.launchCoordinates(
                          double.parse(latlong[0]),
                          double.parse(latlong[1]),
                        );
                      }

                      return showDialog(
                          context: context,
                          builder: (_) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height: 600,
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //------------------------------------------------------------------------IMAGE--------------------------------------------------------//
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(eventImage),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //------------------------------------------------------------------------TITLE------------------------------------------------------------------------//
                                          Row(
                                            children: [
                                              Text(
                                                ("Event :"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                " $eventTitle",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //------------------------------------------------------------------------DESCRIPTION------------------------------------------------------------------------//
                                          Row(
                                            children: [
                                              Text(
                                                ("Details :"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                " $description",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //-------------------------------------------------------------------date----------------------------------------------------------------//
                                          Row(
                                            children: [
                                              Text(
                                                ("Date :"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                " $date",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //------------------------------------------------------------------------TIME------------------------------------------------------------------------//
                                          Row(
                                            children: [
                                              Text(
                                                ("Time :"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                " $time",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //-----------------------------------------------------------------------Google Maps------------------------------------------------------//
                                          SizedBox(
                                            height: 500,
                                            child: GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                      target: LatLng(
                                                        double.parse(
                                                            latlong[0]),
                                                        double.parse(
                                                            latlong[1]),
                                                      ),
                                                      zoom: 18),
                                              mapType: MapType.hybrid,
                                              compassEnabled: true,
                                              markers: markers,
                                              zoomControlsEnabled: false,
                                              zoomGesturesEnabled: true,
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                MarkerId markerId = MarkerId(
                                                    "${(latlong[0])} +${(latlong[1])}");
                                                Marker marker = Marker(
                                                    markerId: markerId,
                                                    position: LatLng(
                                                      double.parse(latlong[0]),
                                                      double.parse(latlong[1]),
                                                    ),
                                                    icon: BitmapDescriptor
                                                        .defaultMarker,
                                                    infoWindow: InfoWindow(
                                                        title: address));

                                                setState(() {
                                                  googleMapController =
                                                      controller;
                                                  markers.add(marker);
                                                });
                                              },
                                              mapToolbarEnabled: true,
                                              scrollGesturesEnabled: true,
                                            ),
                                          ),
                                          Positioned(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  launchMaps();
                                                },
                                                child: Text("GET DIRECTION")),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            ("Location:"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                ' ${controller.allEvent[index].mapAddress}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                              "Created by : ${controller.allEvent[index].creatorName}\n${controller.allEvent[index].email}"),

                                          //-------------------------------------------------------------------JOIN BUTTON-------------------------------------------------//
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            color: Color(
                                                                0xff757575),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Form(
                                                                  key: _formKey,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            name,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            email,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            age,
                                                                      ),
                                                                      ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              primary: Colors
                                                                                  .teal.shade400),
                                                                          onPressed:
                                                                              () {
                                                                            joinEvent(
                                                                                "${controller.allEvent[index].eventId}",
                                                                                "${controller.allEvent[index].eventTitle}",
                                                                                "${controller.allEvent[index].date}",
                                                                                "${controller.allEvent[index].description}",
                                                                                "${controller.allEvent[index].time}",
                                                                                "${controller.allEvent[index].eventImage}",
                                                                                "${controller.allEvent[index].uid}",
                                                                                "${controller.allEvent[index].latitude}",
                                                                                "${controller.allEvent[index].longitude}",
                                                                                "${controller.allEvent[index].mapAddress}",
                                                                                "${controller.allEvent[index].creatorName}",
                                                                                "${controller.allEvent[index].email}");
                                                                          },
                                                                          child:
                                                                              Text("Join")),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors
                                                              .teal.shade400),
                                                  child: const Text("JOIN"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }

                    //==============================================================================================================================================================//

                    return GestureDetector(
                      onTap: () {
                        showDialogfunc(
                          context,
                          controller.allEvent[index].eventImage,
                          controller.allEvent[index].eventTitle,
                          controller.allEvent[index].date,
                          controller.allEvent[index].time,
                          controller.allEvent[index].description,
                          controller.allEvent[index].latitude,
                          controller.allEvent[index].longitude,
                          controller.allEvent[index].mapAddress,
                          controller.allEvent[index].creatorName,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 15,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${controller.allEvent[index].eventImage}'),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.8),
                                    BlendMode.dstOut),
                              ),
                            ),
                            child: Row(
                              children: [
                                //<------------------------------------------------------EVENT -------------------------------------------------------->
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    height: 100,
                                    width: 100,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        '${controller.allEvent[index].eventImage}',
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${controller.allEvent[index].eventTitle}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        "${controller.allEvent[index].description}",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //<-------------------------------------------------------------------------------------------------------------->
                                // SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
