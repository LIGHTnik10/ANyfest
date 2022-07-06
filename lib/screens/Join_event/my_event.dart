import 'package:anyfest/model/data_model.dart';
import 'package:anyfest/model/user_model.dart';
import 'package:anyfest/screens/chats/one_one_message.dart';
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

class MyEvent extends StatefulWidget {
  const MyEvent({Key? key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final DataController controller = Get.put(DataController());
  GeoCode geoCode = GeoCode();
  late GoogleMapController googleMapController;
  //==================================================================//
  Set<Marker> markers = {};
  late Position position;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.myEvent();
    });
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        title: const Text("Event Joined"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 5,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: GetBuilder<DataController>(
                builder: (controller) => controller.myevent.isEmpty
                    ? const Center(
                        child: Text('😔 NO EVENT JOINED 😔'),
                      )
                    : ListView.builder(
                        itemCount: controller.myevent.length,
                        itemBuilder: (context, index) {
                          leaveEvent(context) {
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: Text(
                                                "DO YOU WANT TO LEAVE THE EVENT: ${controller.myevent[index].eventTitle}?",
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              )),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 30,
                                                                vertical: 10),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      controller.leaveEvent(
                                                          "${controller.myevent[index].eventId}");
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Event : '${controller.myevent[index].eventTitle}' Leaved Sucessfully",
                                                          toastLength: Toast
                                                              .LENGTH_LONG);
                                                    },
                                                    child: const Text("Leave")),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 30,
                                                                vertical: 10),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
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

                          showDialogfunc(context, eventImage, eventTitle, date,
                              time, description) {
                            return showDialog(
                                context: context,
                                builder: (_) {
                                  var latlong =
                                      "${controller.myevent[index].latitude},${controller.myevent[index].longitude}"
                                          .split(",");
                                  var address =
                                      "${controller.myevent[index].eventaddress}";

                                  launchMaps() {
                                    MapsLauncher.launchCoordinates(
                                      double.parse(latlong[0]),
                                      double.parse(latlong[1]),
                                    );
                                  }

                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        height: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //------------------------------------------------------------------------IMAGE--------------------------------------------------------//
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Image.network(eventImage),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                //------------------------------------------------------------------------TITLE------------------------------------------------------------------------//
                                                Text(
                                                  eventTitle,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                //------------------------------------------------------------------------DESCRIPTION------------------------------------------------------------------------//
                                                Text(
                                                  description,
                                                  style: const TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //------------------------------------------------------------------------DATE------------------------------------------------------------------------//
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "DATE:   $date",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    //------------------------------------------------------------------------TIME------------------------------------------------------------------------//
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "TIME:  $time",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 50,
                                                    ),
                                                  ],
                                                ),
                                                //-----------------------------------------------------------------------Google Maps------------------------------------------------------//
                                                SizedBox(
                                                  height: 500,
                                                  child: GoogleMap(
                                                    rotateGesturesEnabled: true,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                            target: LatLng(
                                                              double.parse(
                                                                  latlong[0]),
                                                              double.parse(
                                                                  latlong[1]),
                                                            ),
                                                            zoom: 18),
                                                    myLocationButtonEnabled:
                                                        true,
                                                    mapType: MapType.hybrid,
                                                    compassEnabled: true,
                                                    myLocationEnabled: false,
                                                    markers: markers,
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) {
                                                      MarkerId markerId = MarkerId(
                                                          "${(latlong[0])} +${(latlong[1])}");
                                                      Marker marker = Marker(
                                                          markerId: markerId,
                                                          position: LatLng(
                                                            double.parse(
                                                                latlong[0]),
                                                            double.parse(
                                                                latlong[1]),
                                                          ),
                                                          icon: BitmapDescriptor
                                                              .defaultMarker,
                                                          infoWindow:
                                                              InfoWindow(
                                                                  title:
                                                                      address));

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
                                                      child: const Text(
                                                          "GET DIRECTION")),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                    "LOCATION: ${controller.myevent[index].eventaddress}"),
                                                Text(
                                                    "Created by : ${controller.myevent[index].creatorName}\n${controller.myevent[index].creatorEmail}"),

                                                //-------------------------------------------------------------------JOIN BUTTON-------------------------------------------------//
                                                //<-----------------------------------------------------------DELETE BUTTON TO LEAVE EVENT--------------------------------------------------->
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        leaveEvent(
                                                          context,
                                                        );
                                                      },
                                                      child:
                                                          const Text('Leave'),
                                                    ),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .teal
                                                                    .shade400),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          chatpage(
                                                                            email:
                                                                                '${user!.email}',
                                                                          )));
                                                        },
                                                        child: const Text(
                                                            "Chats")),
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

                          controller.myevent[index].eventId;
                          return GestureDetector(
                            onTap: () {
                              showDialogfunc(
                                context,
                                controller.myevent[index].eventImage,
                                controller.myevent[index].eventTitle,
                                controller.myevent[index].date,
                                controller.myevent[index].time,
                                controller.myevent[index].description,
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 15,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${controller.myevent[index].eventImage}'),
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
                                        decoration: const BoxDecoration(),
                                        height: 100,
                                        width: 100,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            '${controller.myevent[index].eventImage}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${controller.myevent[index].eventTitle}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "${controller.myevent[index].description}",
                                            style: const TextStyle(
                                                color: Colors.black45,
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
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future refresh() async {
    setState(() {
      controller.myevent.length;
    });
  }
}
