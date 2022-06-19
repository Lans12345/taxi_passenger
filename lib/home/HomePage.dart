import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/pages/hotline.dart';
import 'package:taxi/pages/operator.dart';
import 'package:taxi/pages/privacy.dart';
import 'package:taxi/pages/termsOfUse.dart';
import 'package:taxi/profile/profile.dart';
import 'package:taxi/utils/aboutUs.dart';
import '../advanceBooking/advanceBooking.dart';
import '../bookAFriend/bookAFriend.dart';
import '../bookNow/bookNow.dart';
import '../provider/userProvider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

late double lat;
late double long;

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _determinePosition();
    getLocation();
    getData1();
    marker1();
  }

  DateTime datetime = DateTime.now();

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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(lat, long),
    zoom: 16,
  );

  Set<Marker> markers = {};

  marker1() async {
    Marker mark1 = Marker(
        markerId: const MarkerId('mark1'),
        infoWindow: const InfoWindow(
          title: 'Current Location',
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, long));

    setState(() {
      markers.add(mark1);
    });
  }

  mar(
      String thisId,
      String thisFirstName,
      String thisLastName,
      String thisContactNumber,
      String thisProfilePicture,
      double thisRating,
      String thisCarModel,
      String carPlateNumber,
      double thisLat,
      double thisLong,
      String thisUsername,
      String thisPassword,
      String thisCarPicture,
      double locLat,
      double locLong) async {
    if (thisProfilePicture == '') {
      thisProfilePicture =
          'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    }
    print('calued');
    markers.add(Marker(
        markerId: MarkerId(thisId),
        infoWindow: InfoWindow(
            title: thisFirstName + ' ' + thisLastName,
            snippet: thisContactNumber,
            onTap: () async {
              bool result = await InternetConnectionChecker().hasConnection;

              if (result == true) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Colors.grey[100],
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Driver',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.bold),
                                    )),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(Icons.close,
                                      color: Colors.black),
                                ),
                              ]),
                          content: SizedBox(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  CircleAvatar(
                                    minRadius: 40,
                                    maxRadius: 40,
                                    backgroundImage:
                                        NetworkImage(thisProfilePicture),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
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
                                        thisRating.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                    ],
                                  )
                                ]),
                                const SizedBox(width: 10),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        thisFirstName + ' ' + thisLastName,
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        thisCarModel,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Quicksand',
                                            fontSize: 12.0),
                                      ),
                                      const SizedBox(height: 7),
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                            color: Colors.red[200],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Text(
                                                carPlateNumber,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      prefs.setString(
                                          'driverFirstName', thisFirstName);
                                      prefs.setString(
                                          'driverLastName', thisLastName);
                                      prefs.setString('driverContactNumber',
                                          thisContactNumber);
                                      prefs.setString('driverProfilePicture',
                                          thisProfilePicture);
                                      prefs.setDouble(
                                          'driverRating', thisRating);

                                      context
                                          .read<UserProvider>()
                                          .myContactNumber(thisContactNumber);

                                      prefs.setString(
                                          'driverCarModel', thisCarModel);

                                      prefs.setString(
                                          'driverUsername', thisUsername);
                                      prefs.setString(
                                          'driverPassword', thisPassword);

                                      prefs.setString('driverCarPlateNumber',
                                          carPlateNumber);

                                      context
                                          .read<UserProvider>()
                                          .myCarPicture(thisCarPicture);

                                      context
                                          .read<UserProvider>()
                                          .myLocLat(locLat);

                                      context
                                          .read<UserProvider>()
                                          .myLocLong(locLong);

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdvanceBooking()));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('Advance \nBooking',
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.red))),
                                          ]),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      prefs.setString(
                                          'driverFirstName', thisFirstName);
                                      prefs.setString(
                                          'driverLastName', thisLastName);
                                      prefs.setString('driverContactNumber',
                                          thisContactNumber);
                                      prefs.setString('driverProfilePicture',
                                          thisProfilePicture);
                                      prefs.setDouble(
                                          'driverRating', thisRating);

                                      prefs.setString(
                                          'driverCarModel', thisCarModel);

                                      prefs.setString('driverCarPlateNumber',
                                          carPlateNumber);
                                      prefs.setString(
                                          'driverUsername', thisUsername);
                                      prefs.setString(
                                          'driverPassword', thisPassword);

                                      context
                                          .read<UserProvider>()
                                          .myContactNumber(thisContactNumber);

                                      context
                                          .read<UserProvider>()
                                          .myCarPicture(thisCarPicture);

                                      context
                                          .read<UserProvider>()
                                          .myLocLat(locLat);

                                      context
                                          .read<UserProvider>()
                                          .myLocLong(locLong);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BookAFriend()));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('Book a \nFriend',
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.red))),
                                          ]),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      prefs.setString(
                                          'driverFirstName', thisFirstName);
                                      prefs.setString(
                                          'driverLastName', thisLastName);
                                      prefs.setString('driverContactNumber',
                                          thisContactNumber);
                                      prefs.setString('driverProfilePicture',
                                          thisProfilePicture);
                                      prefs.setDouble(
                                          'driverRating', thisRating);

                                      prefs.setString(
                                          'driverCarModel', thisCarModel);

                                      prefs.setString('driverCarPlateNumber',
                                          carPlateNumber);
                                      prefs.setString(
                                          'driverUsername', thisUsername);
                                      prefs.setString(
                                          'driverPassword', thisPassword);

                                      context
                                          .read<UserProvider>()
                                          .myContactNumber(thisContactNumber);

                                      context
                                          .read<UserProvider>()
                                          .myCarPicture(thisCarPicture);

                                      context
                                          .read<UserProvider>()
                                          .myLocLat(locLat);

                                      context
                                          .read<UserProvider>()
                                          .myLocLong(locLong);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BookNow()));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('Book Now',
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.red))),
                                          ]),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No Internet Connection'),
                  ),
                );
              }
            }),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(24, 24),
          ),
          'lib/images/driver.png',
        ),
        position: LatLng(thisLat, thisLong)));
  }

  getData1() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('driver')
        .where('status', isEqualTo: 'driver');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        mar(
          data['firstName'],
          data['firstName'],
          data['lastName'],
          data['contactNumber'],
          data['profilePicture'],
          data['rating'],
          data['carModel'],
          data['carPlateNumber'],
          data['latitude'],
          data['longitude'],
          data['username'],
          data['password'],
          data['carPicture'],
          data['latitude'],
          data['longitude'],
        );
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
                  getData1();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  getData1();
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
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Privacy()));
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('HOME',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.white),
            )),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              iconSize: 28,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

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
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.refresh,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Refresh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.red,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text('HISTORY',
                          style: GoogleFonts.teko(
                            textStyle: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('history-user-' +
                                context.read<UserProvider>().getUsername +
                                '-' +
                                context.read<UserProvider>().getPassword)
                            .where('userUserName',
                                isEqualTo:
                                    context.read<UserProvider>().getUsername)
                            .where('userPassword',
                                isEqualTo:
                                    context.read<UserProvider>().getPassword)
                            .where('type', isEqualTo: 'history')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('error');
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            print('waiting');
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data?.size ?? 0,
                                itemBuilder: (context, index) {
                                  return Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(children: [
                                                      const Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          data.docs[index]
                                                              ['destination'],
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Quicksand',
                                                            color: Colors.red,
                                                            fontSize: 11.0,
                                                          )),
                                                    ]),
                                                    const SizedBox(height: 10),
                                                    Row(children: [
                                                      const Icon(
                                                        Icons
                                                            .my_location_rounded,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        data.docs[index]
                                                            ['pickUpLocation'],
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Quicksand',
                                                          color: Colors.red,
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                    ]),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            data.docs[index]
                                                                ['date'],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Quicksand',
                                                                color: Colors
                                                                    .red[200],
                                                                fontSize: 10.0),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Text(
                                                            data.docs[index]
                                                                ['amountPaid'],
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14.0),
                                                          ),
                                                        ]),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                                }),
                          );
                        })
                  ]),
            ),
          ],
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
