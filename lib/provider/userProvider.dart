import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // Variables
  late String username = '';
  late String password = '';
  late String carPicture = '';
  late double locLat = 0;
  late double locLong = 0;

  late String contactNumber = '';

  late double totalFare = 0;

  // Getters to Call (Getting Data)
  String get getUsername => username;
  String get getPassword => password;
  String get getCarPicture => carPicture;
  double get getLat => locLat;
  double get getLong => locLong;

  double get getTotalFare => totalFare;

  String get getContactNumber => contactNumber;

  // Functions to Call (Passing Data)
  void myUserName(String userName) {
    username = userName;
    notifyListeners();
  }

  void myPassword(String passWord) {
    password = passWord;

    notifyListeners();
  }

  void myContactNumber(String contact) {
    contactNumber = contact;

    notifyListeners();
  }

  void myCarPicture(String car) {
    carPicture = car;

    notifyListeners();
  }

  void myLocLat(double lat) {
    locLat = lat;

    notifyListeners();
  }

  void myLocLong(double long) {
    locLong = long;

    notifyListeners();
  }

  void myTotalFare(double fare) {
    totalFare = fare;

    notifyListeners();
  }
}
