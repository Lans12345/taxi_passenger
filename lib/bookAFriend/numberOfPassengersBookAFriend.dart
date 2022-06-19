import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/bookAFriend/bookAFriendConfirmation.dart';

class NumberOfPassengersBookAFriend extends StatefulWidget {
  int numberOfPassengersBookAFriend = 0;

  NumberOfPassengersBookAFriend({required this.numberOfPassengersBookAFriend});

  @override
  State<NumberOfPassengersBookAFriend> createState() =>
      _NumberOfPassengersBookNowState();
}

class _NumberOfPassengersBookNowState
    extends State<NumberOfPassengersBookAFriend> {
  int numberOfPassengers = 1;
  String nameOfFriend = '';
  String contactNumberOfFriend = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      content: SizedBox(
        height: 220,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Number of Passengers',
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (numberOfPassengers == 1) {
                      } else {
                        setState(() {
                          numberOfPassengers--;
                        });
                      }

                      print(numberOfPassengers);
                    },
                    icon: const Image(
                      color: Colors.black,
                      fit: BoxFit.contain,
                      width: 12,
                      image: AssetImage('lib/images/minus.png'),
                    ),
                  ),
                  Text(
                    '$numberOfPassengers',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 24.0),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        numberOfPassengers++;
                      });
                      print(numberOfPassengers);
                    },
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.red, fontFamily: 'Quicksand'),
                  onChanged: (_userName) {
                    nameOfFriend = _userName;
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: 'Name of Friend',
                    labelStyle: const TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.red, fontFamily: 'Quicksand'),
                  onChanged: (_contactNumberOfFriend) {
                    contactNumberOfFriend = _contactNumberOfFriend;
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.phone,
                      color: Colors.red,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: 'Contact Number of Friend',
                    labelStyle: const TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ]),
      ),
      actions: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => Navigator.of(context)..pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            FlatButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt('passengers', numberOfPassengers);
                prefs.setString('nameOfFriend', nameOfFriend);
                prefs.setString('contactNumberOfFriend', contactNumberOfFriend);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BookAFriendConfirmation()));
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
