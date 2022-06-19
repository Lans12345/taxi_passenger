import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi/pages/privacy.dart';

import '../home/HomePage.dart';
import '../profile/profile.dart';
import '../utils/aboutUs.dart';
import 'hotline.dart';
import 'operator.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({Key? key}) : super(key: key);

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
        title: Text('Terms of Use',
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
    );
  }
}
