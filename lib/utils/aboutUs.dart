import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/HomePage.dart';
import '../pages/hotline.dart';
import '../pages/operator.dart';
import '../pages/privacy.dart';
import '../pages/termsOfUse.dart';
import '../profile/profile.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

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
        title: Text('About Us',
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white))),
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 700,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/images/background.JPG'),
                    fit: BoxFit.fill)),
            child: Container(
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    fit: BoxFit.contain,
                    width: 120,
                    image: AssetImage('lib/images/logo.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'SCiVER IT Solutions',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Developer',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Text(
                      'Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          color: Colors.white,
                          child: const ExpansionTile(
                            leading:
                                Icon(Icons.contact_mail, color: Colors.grey),
                            title: Text(
                              'Contact Details',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Quicksand',
                                fontSize: 18.0,
                              ),
                            ),
                            children: [
                              ListTile(
                                subtitle: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand',
                                    fontSize: 10.0,
                                  ),
                                ),
                                title: Text(
                                  'sciveritsolutions@gmail.com',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              ListTile(
                                subtitle: Text(
                                  'Contact Number',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand',
                                    fontSize: 10.0,
                                  ),
                                ),
                                title: Text(
                                  '09090104355',
                                  style: TextStyle(
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
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    'All Right Reserved',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
