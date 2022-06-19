import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/bookNow/bookNowConfirmation.dart';

class NumberOfPassengersBookNow extends StatefulWidget {
  int numberONumberOfPassengersBookNow = 0;

  NumberOfPassengersBookNow({required this.numberONumberOfPassengersBookNow});

  @override
  State<NumberOfPassengersBookNow> createState() =>
      _NumberOfPassengersBookNowState();
}

class _NumberOfPassengersBookNowState extends State<NumberOfPassengersBookNow> {
  int numberOfPassengers = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 60,
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BookNowConfirmation()));
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
