import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/advanceBooking/bookingConfirmation.dart';

class CounterPassenger extends StatefulWidget {
  int numberOfPassenger;

  CounterPassenger({required this.numberOfPassenger});

  @override
  State<CounterPassenger> createState() => _CounterPassengerState();
}

class _CounterPassengerState extends State<CounterPassenger> {
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
    return AlertDialog(
      content: SizedBox(
        height: 210,
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _selectDate();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'select PICK UP DATE'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              selectDate(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  _selectTime();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'select PICK UP TIME'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              selectTime(),
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

                prefs.setString('time', getTime(selectedTime));
                prefs.setString('date', getDate());
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AdvanceBookingConfirmation()));
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
