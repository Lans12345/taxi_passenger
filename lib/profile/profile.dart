import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/home/HomePage.dart';
import 'package:taxi/home/setProfile.dart';
import 'package:taxi/logIn/logIn.dart';
import 'package:taxi/pages/hotline.dart';
import 'package:taxi/pages/operator.dart';
import 'package:taxi/pages/termsOfUse.dart';
import 'package:taxi/utils/aboutUs.dart';

import '../pages/privacy.dart';
import '../provider/userProvider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String firstName = '';
  late String lastName = '';
  late String contactNumber = '';
  late String email = '';
  late String barangay = '';
  late String municipality = '';
  late String city = '';
  late String emergencyName = '';
  late String emergencyContactNumber = '';
  late String emergencyAddress = '';

  @override
  void initState() {
    super.initState();
    getData();
    getData1();
  }

  late String getUserName = '';
  late String getPassword = '';

  late String getfirstName = '';
  late String getlastName = '';
  late String getcontactNumber = '';
  late String getemail = '';
  late String getbarangay = '';
  late String getmunicipality = '';
  late String getcity = '';
  late String getemergencyName = '';
  late String getemergencyContactNumber = '';
  late String getemergencyAddress = '';
  late String getprofilePicture =
      'https://cdn-icons-png.flaticon.com/512/64/64572.png';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
      contactNumber = prefs.getString('contactNumber')!;
      email = prefs.getString('email')!;
      barangay = prefs.getString('barangay')!;
      municipality = prefs.getString('municipality')!;
      city = prefs.getString('city')!;
      emergencyName = prefs.getString('emergencyName')!;
      emergencyContactNumber = prefs.getString('emergencyContactNumber')!;
      emergencyAddress = prefs.getString('emergencyAddress')!;

      getUserName = prefs.getString('username')!;
      getPassword = prefs.getString('password')!;
    });
  }

  getData1() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('user')
        .where('status', isEqualTo: 'user')
        .where('password', isEqualTo: context.read<UserProvider>().getPassword)
        .where('username', isEqualTo: context.read<UserProvider>().getUsername);
    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        getfirstName = data['firstName'];
        getlastName = data['lastName'];
        getcontactNumber = data['contactNumber'];
        getemail = data['email'];
        getbarangay = data['barangay'];
        getmunicipality = data['municipality'];
        getcity = data['city'];
        getemergencyName = data['emergencyName'];
        getemergencyContactNumber = data['emergencyContactNumber'];
        getemergencyAddress = data['emergencyAddress'];
        getprofilePicture = data['profilePicture'];
      }
    });
  }

  late double rating = 5;

  @override
  Widget build(BuildContext context) {
    if (getprofilePicture == '') {
      getprofilePicture = 'https://cdn-icons-png.flaticon.com/512/64/64572.png';
    }
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Profile()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text("Home"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
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
              title: Text('PROFILE',
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
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('setProfile', false);
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
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                    backgroundColor: Colors.white,
                    minRadius: 50,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(
                      getprofilePicture,
                    )),
                const SizedBox(
                  height: 3,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () async {
                      bool result =
                          await InternetConnectionChecker().hasConnection;

                      if (result == true) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SetProfile()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No Internet Connection'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      color: Colors.black26,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 10.0,
                              fontFamily: 'Quicksand',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 450,
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          getfirstName + " " + getlastName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24.0,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const SizedBox(
                            height: 30,
                            child: TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black,
                              labelStyle: TextStyle(
                                fontFamily: 'Quicksand',
                              ),
                              tabs: [
                                Tab(
                                  text: 'Details',
                                ),
                                Tab(
                                  text: 'History',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          children: [
                            ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40, top: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: ListTile(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.phone,
                                        color: Colors.red,
                                      ),
                                      tileColor: Colors.white,
                                      title: Text(
                                        getcontactNumber,
                                      ),
                                      subtitle: const Text(
                                        'Contact Number',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40, top: 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.email,
                                        color: Colors.red,
                                      ),
                                      tileColor: Colors.white,
                                      title: Text(
                                        getemail,
                                      ),
                                      subtitle: const Text(
                                        'Email Address',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40, top: 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.location_city_rounded,
                                        color: Colors.red,
                                      ),
                                      tileColor: Colors.white,
                                      title: Text(
                                        getmunicipality,
                                      ),
                                      subtitle: const Text(
                                        'Town/Municipality',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40, top: 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.local_activity_rounded,
                                        color: Colors.red,
                                      ),
                                      tileColor: Colors.white,
                                      title: Text(
                                        getcity,
                                      ),
                                      subtitle: const Text(
                                        'City/Province',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40, top: 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.place_rounded,
                                        color: Colors.red,
                                      ),
                                      tileColor: Colors.white,
                                      title: Text(getbarangay),
                                      subtitle: const Text(
                                        'Barangay',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    child: Container(
                                        color: Colors.grey[200],
                                        child: ExpansionTile(
                                          leading: const Icon(Icons.person_add,
                                              color: Colors.red),
                                          title: const Text(
                                            'Emergency Contact',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Quicksand',
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          children: [
                                            ListTile(
                                              subtitle: const Text(
                                                'Contact Name',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              title: Text(
                                                getemergencyName,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              subtitle: const Text(
                                                'Contact Number',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              title: Text(
                                                getemergencyContactNumber,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              subtitle: const Text(
                                                'Contact Address',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              title: Text(
                                                getemergencyAddress,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('history-user-' +
                                        context
                                            .read<UserProvider>()
                                            .getUsername +
                                        '-' +
                                        context
                                            .read<UserProvider>()
                                            .getPassword)
                                    .where('userUserName',
                                        isEqualTo: context
                                            .read<UserProvider>()
                                            .getUsername)
                                    .where('userPassword',
                                        isEqualTo: context
                                            .read<UserProvider>()
                                            .getPassword)
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
                                  return ListView.builder(
                                      itemCount: snapshot.data?.size ?? 0,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40, right: 40, top: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: ListTile(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                AlertDialog(
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          100],
                                                                  title: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Rate Driver',
                                                                            style:
                                                                                GoogleFonts.teko(
                                                                              textStyle: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                                                                            )),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Icon(
                                                                              Icons.close,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ]),
                                                                  content:
                                                                      SizedBox(
                                                                    height: 150,
                                                                    width: 200,
                                                                    child: Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Column(children: [
                                                                                CircleAvatar(
                                                                                  minRadius: 40,
                                                                                  maxRadius: 40,
                                                                                  backgroundImage: NetworkImage(data.docs[index]['driverProfilePicture']),
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
                                                                                      data.docs[index]['rating'].toString(),
                                                                                      style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ]),
                                                                              const SizedBox(width: 10),
                                                                              Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                const SizedBox(height: 10),
                                                                                Text(
                                                                                  data.docs[index]['driverFirstName'] + ' ' + data.docs[index]['driverLastName'],
                                                                                  style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                                ),
                                                                                const SizedBox(height: 2),
                                                                                Text(
                                                                                  data.docs[index]['carModel'],
                                                                                  style: const TextStyle(color: Colors.grey, fontFamily: 'Quicksand', fontSize: 12.0),
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
                                                                                          data.docs[index]['plateNumber'],
                                                                                          style: const TextStyle(color: Colors.black, fontFamily: 'Quicksand', fontSize: 10.0),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          RatingBar
                                                                              .builder(
                                                                            initialRating:
                                                                                5,
                                                                            minRating:
                                                                                1,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            allowHalfRating:
                                                                                false,
                                                                            itemCount:
                                                                                5,
                                                                            itemPadding:
                                                                                const EdgeInsets.symmetric(horizontal: 0.0),
                                                                            itemBuilder: (context, _) =>
                                                                                const Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate:
                                                                                (_rating) {
                                                                              setState(() {
                                                                                rating = _rating;
                                                                              });

                                                                              print(_rating);
                                                                            },
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              20,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('driver')
                                                                              .doc(data.docs[index]['driverUserName'] + '-' + data.docs[index]['driverPassword'])
                                                                              .update({
                                                                            'rating':
                                                                                rating,
                                                                          });

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  'RATE',
                                                                                  style: GoogleFonts.teko(
                                                                                    textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.red),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        ),
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.white,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ));
                                                  },
                                                  leading: const Icon(
                                                    Icons.my_location_rounded,
                                                    color: Colors.red,
                                                  ),
                                                  tileColor: Colors.white,
                                                  title: Text(data.docs[index]
                                                          ['destination'] +
                                                      ' - ' +
                                                      data.docs[index]['date']),
                                                  subtitle: Text(
                                                    'From: ' +
                                                        data.docs[index]
                                                            ['pickUpLocation'],
                                                    style: const TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    data.docs[index]
                                                        ['amountPaid'],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            print(context.read<UserProvider>().getUsername);
                            CoolAlert.show(
                                barrierDismissible: false,
                                confirmBtnColor: Colors.red,
                                confirmBtnTextStyle: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                showCancelBtn: true,
                                cancelBtnText: 'Cancel',
                                cancelBtnTextStyle: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                onCancelBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                                context: context,
                                type: CoolAlertType.warning,
                                text: 'Are you sure you want to Log out?',
                                onConfirmBtnTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const LogInPage()));
                                },
                                confirmBtnText: 'Continue');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
                                    child: Text('Log Out',
                                        style: GoogleFonts.teko(
                                          textStyle: const TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        )),
                                  ),
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
                ),
              ],
            )));
  }
}
