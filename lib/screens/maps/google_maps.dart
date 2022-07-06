import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart' as locator;
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
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
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: "$addresslocation"),
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

  Location currentLocation = Location();
  void getLocation() async {
    currentLocation.onLocationChanged.listen((LocationData loc) {
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 18.0,
      )));

      setState(() {
        markers.add(Marker(
            markerId: const MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
    });
  }

//==========================================================================//
  String? city;
  String? addresslocation;

  //==================================================================//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("MAPS"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            rotateGesturesEnabled: true,
            onTap: (tapped) async {
              Address address = await geoCode.reverseGeocoding(
                  latitude: tapped.latitude, longitude: tapped.longitude);
              getMarkers(tapped.latitude, tapped.longitude);
              /* await FirebaseFirestore.instance.collection("Location").add({
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
              });
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(19.09889157004121, 72.85163327432217), zoom: 10),
            myLocationButtonEnabled: false,
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
                      borderSide: const BorderSide(color: Colors.white),
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
          Positioned(
            bottom: 50,
            child: Text(
              "$addresslocation",
              style: const TextStyle(color: Colors.white),
            ),
          ),
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
          ),
        ],
      ),
    );
  }

  late String searchAdd;
  void search() {
    locator.locationFromAddress(searchAdd).then((result) {
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(result[0].latitude, result[0].longitude),
              zoom: 18)));
    });
  }
}
