import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/home/HomePage.dart';
import 'package:taxi/provider/userProvider.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({Key? key}) : super(key: key);

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  late String getUserName = '';
  late String getPassword = '';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      getUserName = prefs.getString('username')!;
      getPassword = prefs.getString('password')!;
    });
  }

  late String emergencyName = '';
  late String emergencyContactNumber = '';
  late String emergencyAddress = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Emergency Contact Details',
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Full Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    emergencyName = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 30,
                  top: 0,
                  bottom: 0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Contact Number',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    emergencyContactNumber = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 30,
                  top: 0,
                  bottom: 0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Complete Address',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    emergencyAddress = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    bool result =
                        await InternetConnectionChecker().hasConnection;

                    if (result == true) {
                      print(context.read<UserProvider>().getContactNumber);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('setProfile', true);
                      prefs.setString('emergencyName', emergencyName);
                      prefs.setString(
                          'emergencyContactNumber', emergencyContactNumber);
                      prefs.setString('emergencyAddress', emergencyAddress);

                      FirebaseFirestore.instance
                          .collection('user')
                          .doc('$getUserName-$getPassword')
                          .update({
                        'emergencyName': emergencyName,
                        'emergencyContactNumber': emergencyContactNumber,
                        'emergencyAddress': emergencyAddress,
                      });

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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Continue',
                              style: GoogleFonts.teko(
                                textStyle: const TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                      ]),
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
      ),
    );
  }
}
