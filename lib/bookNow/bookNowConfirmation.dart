import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/bookNow/driverOnTheWay.dart';
import 'package:taxi/home/HomePage.dart';
import 'package:taxi/pages/hotline.dart';
import 'package:taxi/pages/operator.dart';
import 'package:taxi/pages/termsOfUse.dart';
import 'package:taxi/profile/profile.dart';
import 'package:taxi/utils/aboutUs.dart';

import '../pages/privacy.dart';
import '../provider/userProvider.dart';

class BookNowConfirmation extends StatefulWidget {
  const BookNowConfirmation({Key? key}) : super(key: key);

  @override
  State<BookNowConfirmation> createState() => _BookNowConfirmationState();
}

class _BookNowConfirmationState extends State<BookNowConfirmation> {
  @override
  void initState() {
    super.initState();

    getData();
    getData1();
    getData2();
    getData3();
  }

  DateTime datetime1 = DateTime.now();

  late int myMonth = 0;
  late int myWeek = 0;
  late int myYear = 0;

  getData1() async {
    String month = DateFormat.MMMM().format(datetime1);

    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('analytics')
        .where('type', isEqualTo: 'month');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        myMonth = data[month];
      }
    });
  }

  getData2() async {
    String week = DateFormat.EEEE().format(datetime1);

    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('analytics')
        .where('type', isEqualTo: 'week');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        myWeek = data[week];
      }
    });
  }

  getData3() async {
    String year = DateFormat.y().format(datetime1);
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('analytics')
        .where('type', isEqualTo: 'year');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        myYear = data[year];
      }
    });
  }

  late String date = '';
  late String time = '';
  late int passengers = 0;
  late String firstName = '';
  late String lastName = '';
  late String contactNumber = '';
  late String location = '';
  late String destination = '';
  late int distance = 0;
  late double locationLat = 0;

  late double locationLong = 0;

  late double destinationLat = 0;

  late double destinationLong = 0;
  late String nameOfFriend = '';
  late String contactNumberOfFriend = '';

  late String driverFirstName = '';
  late String driverLastName = '';
  late String driverContactNumber = '';
  late String driverProfilePicture = '';
  late double driverRating = 0;
  late String driverCarModel = '';
  late String driverCarPlateNumber = '';
  late String driverUsername = '';
  late String driverPassword = '';

  late int numberOfPassengers = 0;
  late String profilePicture = '';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      date = prefs.getString('date')!;
      time = prefs.getString('time')!;
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
      contactNumber = prefs.getString('contactNumber')!;
      passengers = prefs.getInt('passengers')!;
      location = prefs.getString('location')!;
      destination = prefs.getString('destination')!;
      distance = prefs.getInt('distance')!;
      locationLat = prefs.getDouble('locationLat')!;
      locationLong = prefs.getDouble('locationLong')!;
      destinationLat = prefs.getDouble('destinationLat')!;
      destinationLong = prefs.getDouble('destinationLong')!;
      nameOfFriend = prefs.getString('nameOfFriend')!;
      contactNumberOfFriend = prefs.getString('contactNumberOfFriend')!;
      driverFirstName = prefs.getString('driverFirstName')!;
      driverLastName = prefs.getString('driverLastName')!;
      driverContactNumber = prefs.getString('driverContactNumber')!;
      driverProfilePicture = prefs.getString('driverProfilePicture')!;
      driverRating = prefs.getDouble('driverRating')!;
      driverCarModel = prefs.getString('driverCarModel')!;
      driverCarPlateNumber = prefs.getString('driverCarPlateNumber')!;
      driverUsername = prefs.getString('driverUsername')!;
      driverPassword = prefs.getString('driverPassword')!;
      numberOfPassengers = prefs.getInt('passengers')!;
      profilePicture = prefs.getString('profilePicture')!;
    });
  }

  var dt = DateTime.now();

  Future history() async {
    final docUser = FirebaseFirestore.instance
        .collection('history-user-' +
            context.read<UserProvider>().getUsername +
            '-' +
            context.read<UserProvider>().getPassword)
        .doc();

    final json = {
      'destination': destination,
      'date': dt.month.toString() +
          '/' +
          dt.day.toString() +
          '/' +
          dt.year.toString(),
      'time': dt.hour.toString() +
          '/' +
          dt.minute.toString() +
          '/' +
          dt.second.toString(),
      'profilePicture': profilePicture,
      'pickUpLocation': location,
      'driverFirstName': driverFirstName,
      'driverLastName': driverLastName,
      'carModel': driverCarModel,
      'plateNumber': driverCarPlateNumber,
      'driverProfilePicture': driverProfilePicture,
      'amountPaid':
          context.read<UserProvider>().getTotalFare.toStringAsFixed(2),
      'driverUserName': driverUsername,
      'driverPassword': driverPassword,
      'rating': driverRating,
      'userContactNumber': contactNumber,
      'type': 'history',
      'userUserName': context.read<UserProvider>().getUsername,
      'userPassword': context.read<UserProvider>().getPassword,
    };

    await docUser.set(json);
  }

  Future booking() async {
    final docUser = FirebaseFirestore.instance.collection('driver').doc(
        dt.month.toString() +
            '-' +
            dt.day.toString() +
            '-' +
            dt.year.toString() +
            '-' +
            dt.hour.toString() +
            '-' +
            dt.minute.toString() +
            '-' +
            dt.second.toString() +
            '-' +
            firstName +
            ' ' +
            lastName);

    final json = {
      'destination': destination,
      'date': dt.month.toString() +
          '-' +
          dt.day.toString() +
          '-' +
          dt.year.toString(),
      'time': dt.hour.toString() +
          '-' +
          dt.minute.toString() +
          '-' +
          dt.second.toString(),
      'profilePicture': profilePicture,
      'pickUpLocation': location,
      'driverFirstName': driverFirstName,
      'driverLastName': driverLastName,
      'carModel': driverCarModel,
      'plateNumber': driverCarPlateNumber,
      'driverProfilePicture': driverProfilePicture,
      'amountPaid':
          context.read<UserProvider>().getTotalFare.toStringAsFixed(2),
      'username': driverUsername,
      'password': driverPassword,
      'rating': driverRating,
      'userContactNumber': contactNumber,
      'bookingType': 'instantBooking',
      'userUserName': context.read<UserProvider>().getUsername,
      'userPassword': context.read<UserProvider>().getPassword,
      'name': firstName + ' ' + lastName,
      'location': location,
      'locationLat': locationLat,
      'locationLong': locationLong,
      'destinationLat': destinationLat,
      'destinationLong': destinationLong,
      'numberOfPassengers': numberOfPassengers,
      'status': 'Driver on the Way',
      'book': 'booking',
      'type': 'bookNow',
      'driverContactNumber': context.read<UserProvider>().getContactNumber,
      'carPicture': context.read<UserProvider>().getCarPicture,
    };

    await docUser.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
        title: Text('Booking Confirmation',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 0,
              bottom: 10,
            ),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Text('Driver',
              style: GoogleFonts.teko(
                textStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                CircleAvatar(
                  minRadius: 50,
                  maxRadius: 50,
                  backgroundImage: NetworkImage(driverProfilePicture),
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
                      image: AssetImage('lib/images/star.png'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      driverRating.toString(),
                      style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    ),
                  ],
                )
              ]),
              const SizedBox(width: 20),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 160,
                      child: Text(
                        driverFirstName + ' ' + driverLastName,
                        style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      driverCarModel,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Quicksand',
                          fontSize: 12.0),
                    ),
                    const SizedBox(height: 7),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.red[200],
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(
                              driverCarPlateNumber,
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
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Column(
            children: [
              Text('Your Trip',
                  style: GoogleFonts.teko(
                    textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Icon(
                    Icons.my_location_rounded,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pick Up Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 9.0,
                      ),
                    ),
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: const SizedBox(
                          width: 250,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Your Current Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Destination Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 9.0,
                      ),
                    ),
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              destination,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
                  ]),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Text('Payment',
              style: GoogleFonts.teko(
                textStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.money_rounded,
                color: Colors.green,
                size: 32.0,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Cash',
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Quicksand',
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 150,
              ),
              Text(
                  '₱' +
                      context
                          .read<UserProvider>()
                          .getTotalFare
                          .toStringAsFixed(2),
                  style: GoogleFonts.teko(
                    textStyle: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 50,
              right: 50,
            ),
            child: ElevatedButton(
              onPressed: () async {
                bool result = await InternetConnectionChecker().hasConnection;

                if (result == true) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey[100],
                            content: SizedBox(
                              height: 220,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Booked Succesfully',
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                color: Colors.green,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                        ]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const []),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [
                                      const Text(
                                        'Driver:',
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        driverFirstName + ' ' + driverLastName,
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    Row(children: [
                                      const Text(
                                        'Contact Number:',
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        driverContactNumber,
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Car: ' + driverCarModel,
                                        style: const TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Quicksand',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Plate #: ' + driverCarPlateNumber,
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            color: Colors.black,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ]),
                                    const Text(
                                      'Color: N/A',
                                      style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                      ),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(children: [
                                      const Text(
                                        'Passenger:',
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '$firstName $lastName',
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    Row(children: [
                                      const Text(
                                        'Number Of Passengers:',
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '$passengers',
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    const Text(
                                      'Pick Up Place: Your Current Location',
                                      style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Destination Place: $destination',
                                      style: const TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: Colors.black,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Amount to Pay:',
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontSize: 10.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '₱' +
                                                context
                                                    .read<UserProvider>()
                                                    .getTotalFare
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Tesla Motors Inc.',
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontSize: 8.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ]),
                                  ]),
                            ),
                            actions: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;

                                    if (result == true) {
                                      booking();
                                      history();
                                      DateTime datetime = DateTime.now();
                                      String month =
                                          DateFormat.MMMM().format(datetime);
                                      print(month);
                                      String week =
                                          DateFormat.EEEE().format(datetime);
                                      print(week);
                                      String year =
                                          DateFormat.y().format(datetime);
                                      print(year);

                                      if (month == 'January') {
                                        FirebaseFirestore.instance
                                            .collection('analytics')
                                            .doc('month')
                                            .update({
                                          month: myMonth + 1,
                                          'February': 0,
                                          'March': 0,
                                          'April': 0,
                                          'May': 0,
                                          'June': 0,
                                          'July': 0,
                                          'August': 0,
                                          'September': 0,
                                          'October': 0,
                                          'November': 0,
                                          'December': 0,
                                        });
                                      } else {
                                        print('month - success');
                                        FirebaseFirestore.instance
                                            .collection('analytics')
                                            .doc('month')
                                            .update({
                                          month: myMonth + 1,
                                        });
                                      }

                                      if (week == 'Monday') {
                                        FirebaseFirestore.instance
                                            .collection('analytics')
                                            .doc('week')
                                            .update({
                                          week: myWeek + 1,
                                          'Tuesday': 0,
                                          'Wednesday': 0,
                                          'Thursday': 0,
                                          'Friday': 0,
                                          'Saturday': 0,
                                          'Sunday': 0,
                                        });
                                      } else {
                                        print('week - success');
                                        FirebaseFirestore.instance
                                            .collection('analytics')
                                            .doc('week')
                                            .update({
                                          week: myWeek + 1,
                                        });
                                      }

                                      FirebaseFirestore.instance
                                          .collection('analytics')
                                          .doc('year')
                                          .update({
                                        year: myYear + 1,
                                      });
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DriverOnTheWay()));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('No Internet Connection'),
                                        ),
                                      );
                                    }
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
                                          Text('CONTINUE',
                                              style: GoogleFonts.teko(
                                                textStyle: const TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              )),
                                        ]),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                  ),
                                ),
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
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('CONFIRM',
                      style: GoogleFonts.teko(
                        textStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )),
                ]),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
