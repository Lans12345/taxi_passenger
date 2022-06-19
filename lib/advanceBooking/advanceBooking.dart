import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart' as location;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/home/HomePage.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:taxi/key.dart';
import 'package:taxi/pages/hotline.dart';
import 'package:taxi/pages/operator.dart';
import 'package:taxi/pages/privacy.dart';
import 'package:taxi/pages/termsOfUse.dart';
import 'package:taxi/profile/profile.dart';
import 'package:taxi/utils/NumberOfPassengerDialog.dart';
import 'package:taxi/utils/aboutUs.dart';

import '../provider/userProvider.dart';

class AdvanceBooking extends StatefulWidget {
  const AdvanceBooking({Key? key}) : super(key: key);
  @override
  State<AdvanceBooking> createState() => _AdvanceBookingState();
}

late double myLat;
late double myLong;

class _AdvanceBookingState extends State<AdvanceBooking> {
  @override
  void initState() {
    getData1();
    super.initState();
  }

  late double farePerKm = 0;
  late double startingFare = 0;

  late double totalFare = 0;

  getData1() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('rate')
        .where('id', isEqualTo: 'rates');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        farePerKm = data['farePerKm'];
        startingFare = data['startingFare'];
      }
    });

    print(farePerKm);
    print(startingFare);
  }

  void onError(location.PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  static const kGoogleApiKey = 'AIzaSyDdXaMN5htLGHo8BkCfefPpuTauwHGXItU';
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final Mode _mode = Mode.overlay;

  // First

  Future<void> pickStartLocation() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search Pick Up Location',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [location.Component(location.Component.country, "ph")]);

    displayPrediction1(p!, homeScaffoldKey.currentState);
  }

  late double startLat;
  late double startLang;

  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;
  late String startInfoWindow = 'Pick Up Location';

  Future<void> displayPrediction1(
      location.Prediction p, ScaffoldState? currentState) async {
    location.GoogleMapsPlaces places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    location.PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId!);

    startLat = detail.result.geometry!.location.lat;
    startLang = detail.result.geometry!.location.lng;

    markersList.add(Marker(
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(12, 12),
          ),
          'lib/images/finish.png',
        ),
        markerId: const MarkerId("0"),
        position: LatLng(startLat, startLang),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {
      startInfoWindow = detail.result.name;
      startLat = detail.result.geometry!.location.lat;
      startLang = detail.result.geometry!.location.lng;
    });
    _getAddress();

    googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(startLat, startLang), 14.0));
  }

  Future<void> pickDestinationLocation() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search Destination Location',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [location.Component(location.Component.country, "ph")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  Future<void> displayPrediction(
      location.Prediction p, ScaffoldState? currentState) async {
    location.GoogleMapsPlaces places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    location.PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId!);

    finishLat = detail.result.geometry!.location.lat;
    finishLang = detail.result.geometry!.location.lng;

    markersList.add(Marker(
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(12, 12),
          ),
          'lib/images/start.png',
        ),
        markerId: const MarkerId("1"),
        position: LatLng(finishLat, finishLang),
        infoWindow: InfoWindow(
          title: detail.result.name,
        )));

    setState(() {
      finishInfoWindow = detail.result.name;
    });
    _getAddress();

    googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(finishLat, finishLang), 14.0));
  }

  late double finishLat;
  late double finishLang;

  late String finishInfoWindow = 'Destination Location';

  final CameraPosition _initialLocation =
      const CameraPosition(target: LatLng(17.227866, 120.573958), zoom: 10);
  late GoogleMapController mapController;

  late Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  final String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return SizedBox(
      height: 50,
      width: width * 0.8,
      child: TextField(
        textCapitalization: TextCapitalization.words,
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = startLat;

      double startLongitude = startLang;

      double destinationLatitude = finishLat;
      double destinationLongitude = finishLang;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
          markerId: MarkerId(startCoordinatesString),
          position: LatLng(startLatitude, startLongitude),
          infoWindow: InfoWindow(
            title: 'Start $startCoordinatesString',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker);

      // Destination Location Marker
      Marker destinationMarker = Marker(
          markerId: MarkerId(destinationCoordinatesString),
          position: LatLng(destinationLatitude, destinationLongitude),
          infoWindow: InfoWindow(
            title: 'Destination $destinationCoordinatesString',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker);

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLat <= finishLat) ? startLat : finishLat;
      double minx = (startLang <= finishLang) ? startLang : finishLang;
      double maxy = (startLat <= finishLat) ? finishLat : startLat;
      double maxx = (startLang <= finishLang) ? finishLang : startLang;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(
              northEastLatitude,
              northEastLongitude,
            ),
            southwest: LatLng(
              southWestLatitude,
              southWestLongitude,
            ),
          ),
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator.bearingBetween(
      //   startLatitude,
      //   startLongitude,
      //   destinationLatitude,
      //   destinationLongitude,
      // );

      await _createPolylines(startLat, startLang, finishLat, finishLang);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.key, // Google Maps API Key
      PointLatLng(startLat, startLang),
      PointLatLng(finishLat, finishLang),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  bool _isVisible = false;

  static final Marker _mark = Marker(
      markerId: const MarkerId('mark'),
      infoWindow: const InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(myLat, myLong));

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

  // Select for Date
  Future<DateTime> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  String getDate() {
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Widget selectDate() {
    if (getDate() == null) {
      return const Text(
        'DATE NOT SET',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      );
    } else {
      return Text(
        getDate(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      );
    }
  }

  Widget selectTime() {
    // ignore: unnecessary_null_comparison
    if (getTime(selectedTime) == null) {
      return const Text(
        'TIME NOT SET',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      );
    } else {
      return Text(
        getTime(selectedTime),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      );
    }
  }

  int numberOfPassengers = 1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Profile()));
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AboutUs()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Privacy Policy"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Privacy()));
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Advance Booking',
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
        key: homeScaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markersList),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                googleMapController = controller;
              },
            ),

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  bottom: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.red.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.34,
                  minChildSize: 0.1,
                  maxChildSize: 0.34,
                  builder: ((context, scrollController) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.red,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: SafeArea(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                    width: width * 0.9,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0, bottom: 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('PLACES'.toUpperCase(),
                                              style: GoogleFonts.teko(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              )),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.looks_one,
                                                  color: Colors.white),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  pickStartLocation();
                                                },
                                                child: ClipRRect(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                    ),
                                                    width: 220,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 10, 20, 10),
                                                      child: Text(
                                                          startInfoWindow,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(
                                                  Icons.location_on_rounded,
                                                  color: Colors.white),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.looks_two,
                                                  color: Colors.white),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  pickDestinationLocation();
                                                  polylineCoordinates.clear();
                                                  _placeDistance = '0';
                                                },
                                                child: ClipRRect(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                    ),
                                                    width: 220,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 10, 20, 10),
                                                      child: Text(
                                                          finishInfoWindow,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(Icons.my_location,
                                                  color: Colors.white),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Visibility(
                                            visible: _placeDistance == null
                                                ? false
                                                : true,
                                            child: Text(
                                              'DISTANCE: $_placeDistance km',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: (startInfoWindow !=
                                                              '' &&
                                                          finishInfoWindow !=
                                                              '')
                                                      ? () async {
                                                          final prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          int dist = int.parse(
                                                              _placeDistance!);
                                                          // Adding the markers to the list
                                                          bool result =
                                                              await InternetConnectionChecker()
                                                                  .hasConnection;

                                                          if (result == true) {
                                                            prefs.setString(
                                                                'location',
                                                                startInfoWindow);
                                                            prefs.setString(
                                                                'destination',
                                                                finishInfoWindow);
                                                            prefs.setInt(
                                                                'distance',
                                                                dist);
                                                            prefs.setDouble(
                                                                'locationLat',
                                                                startLat);
                                                            prefs.setDouble(
                                                                'locationLong',
                                                                startLang);
                                                            prefs.setDouble(
                                                                'destinationLat',
                                                                finishLat);
                                                            prefs.setDouble(
                                                                'destinationLong',
                                                                finishLang);

                                                            startAddressFocusNode
                                                                .unfocus();
                                                            desrinationAddressFocusNode
                                                                .unfocus();
                                                            setState(() {
                                                              if (markers
                                                                  .isNotEmpty) {
                                                                markers.clear();
                                                              }
                                                              if (polylines
                                                                  .isNotEmpty) {
                                                                polylines
                                                                    .clear();
                                                              }
                                                              if (polylineCoordinates
                                                                  .isNotEmpty) {
                                                                polylineCoordinates
                                                                    .clear();
                                                              }
                                                              _placeDistance =
                                                                  null;
                                                            });

                                                            _calculateDistance()
                                                                .then(
                                                                    (isCalculated) {
                                                              _isVisible = true;

                                                              if (isCalculated) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Distance Calculated Sucessfully'),
                                                                  ),
                                                                );
                                                              } else {
                                                                _isVisible =
                                                                    false;

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Error Calculating Distance'),
                                                                  ),
                                                                );
                                                              }
                                                            });
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'No Internet Connection'),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      : null,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Show Route'
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Visibility(
                                                  visible: _isVisible,
                                                  child: Column(children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _getAddress();

                                                        double fare = farePerKm *
                                                            double.parse(
                                                                _placeDistance!);

                                                        totalFare =
                                                            fare + startingFare;

                                                        context
                                                            .read<
                                                                UserProvider>()
                                                            .myTotalFare(
                                                                totalFare);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                CounterPassenger(
                                                                    numberOfPassenger:
                                                                        numberOfPassengers));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: Text(
                                                          'confirm locations'
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Show current location button
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    googleMapController.dispose();
    mapController.dispose();
    destinationAddressController.dispose();
    startAddressController.dispose();

    super.dispose();
  }
}
