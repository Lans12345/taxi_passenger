import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/logIn/logIn.dart';
import 'package:taxi/screens/introductions.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool('userLoggedIn') == true) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LogInPage()));
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Introduction()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Image(
                        width: 150,
                        image: AssetImage('lib/images/logo.png'),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
