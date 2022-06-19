import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/home/HomePage.dart';
import 'package:taxi/profile/profile.dart';
import 'package:taxi/utils/aboutUs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/hotline.dart';
import '../pages/operator.dart';
import '../pages/termsOfUse.dart';
import '../provider/userProvider.dart';

class DriverOnTheWay extends StatefulWidget {
  @override
  State<DriverOnTheWay> createState() => DriverOnTheWayState();
}

late double lat;
late double long;

class DriverOnTheWayState extends State<DriverOnTheWay> {
  @override
  void initState() {
    super.initState();

    getData1();
    _determinePosition();
    getLocation();
    marker();
  }

  marker() async {
    Marker mark = Marker(
        markerId: const MarkerId('mark'),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Waiting for driver',
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(
          context.read<UserProvider>().getLat,
          context.read<UserProvider>().getLong,
        ));

    markers.add(mark);
  }

  getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      prefs.setDouble('myLat', lat);
      prefs.setDouble('myLong', long);
    });
    print('lat - $lat');
    print('long - $long');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  final Completer<GoogleMapController> _controller = Completer();

  // ignore: prefer_final_fields

  Set<Marker> markers = {};

  late String confirmation = '';
  late String driverName = '';
  late String driverContactNumber = '';
  late String driverProfilePicture = '';
  late String carPicture = '';
  late String carModel = '';
  late String plateNumber = '';
  late double rating = 0;
  late double locationLat = 0;
  late double locationLong = 0;
  late String date = '';
  late String time = '';

  getData1() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('driver')
        .where('type', isEqualTo: 'bookNow')
        .where('bookingType', isEqualTo: 'instantBooking')
        .where('userPassword',
            isEqualTo: context.read<UserProvider>().getPassword)
        .where('userUserName',
            isEqualTo: context.read<UserProvider>().getUsername);
    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        confirmation = data['status'];
        driverName = data['driverFirstName'] + ' ' + data['driverLastName'];
        driverContactNumber = data['driverContactNumber'];
        carModel = data['carModel'];
        plateNumber = data['plateNumber'];
        driverProfilePicture = data['driverProfilePicture'];
        rating = data['rating'];
        locationLat = data['locationLat'];
        locationLong = data['locationLong'];
        carPicture = data['carPicture'];
        date = data['date'];
        time = data['time'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: 220,
        child: Drawer(
          child: ListView(
            padding: const EdgeInsets.only(top: 0),
            children: <Widget>[
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                accountEmail: Text("ilocostransport@gmail.com"),
                accountName: Text("Ilocos Transport Cooperative"),
                currentAccountPicture: CircleAvatar(
                  minRadius: 50,
                  maxRadius: 50,
                  backgroundImage: AssetImage('lib/images/logo.png'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About Us"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AboutUs()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Privacy Policy"),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(confirmation,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white),
            )),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              iconSize: 28,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Hotline()));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Hotline()));
                      },
                      child: const Text("Hotlines"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Operator()));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Operator()));
                      },
                      child: const Text("Operator"),
                      value: 2,
                    ),
                    PopupMenuItem(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TermsOfUse()));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TermsOfUse()));
                      },
                      child: const Text("Terms of Use"),
                      value: 3,
                    ),
                  ])
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          mapToolbarEnabled: false,
          markers: Set<Marker>.from(markers),
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                context.read<UserProvider>().getLat,
                context.read<UserProvider>().getLong,
              ),
              zoom: 16),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 210.0,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("lib/images/background.JPG"),
                      fit: BoxFit.cover)),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            minRadius: 40,
                            maxRadius: 40,
                            backgroundImage: NetworkImage(driverProfilePicture),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black38,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(children: [
                                  Text(
                                    driverName,
                                    style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    driverContactNumber,
                                    style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Image(
                                        color: Colors.amber,
                                        fit: BoxFit.contain,
                                        width: 12,
                                        image:
                                            AssetImage('lib/images/star.png'),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        rating.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            minRadius: 40,
                            maxRadius: 40,
                            backgroundImage: NetworkImage(carPicture),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black38,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(children: [
                                  Text(
                                    carModel,
                                    style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    plateNumber,
                                    style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                ]),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final _text = 'sms:$driverContactNumber';
                        if (await canLaunch(_text)) {
                          await launch(_text);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('MESSAGE',
                                  style: GoogleFonts.teko(
                                    textStyle: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            ]),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final _call = 'tel:$driverContactNumber';
                        if (await canLaunch(_call)) {
                          await launch(_call);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('CALL DRIVER',
                                  style: GoogleFonts.teko(
                                    textStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            ]),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: ElevatedButton(
                onPressed: () async {
                  bool result = await InternetConnectionChecker().hasConnection;

                  if (result == true) {
                    FirebaseFirestore.instance
                        .collection('driver')
                        .doc(date + '-' + time)
                        .delete();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No Internet Connection'),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('HOME',
                            style: GoogleFonts.teko(
                              textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ]),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
