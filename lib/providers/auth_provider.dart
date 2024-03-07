import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get loading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<dynamic> register(String fName, String email, String dob,
      String phoneNumber, String postalAddress, String specialization) async {
    try {
      setLoading(true);
      print("Provier register");
      Response res = await http
          .post(Uri.parse("http://35.78.76.21:8000/post/subMatterEx"), body: {
        "Name": fName,
        "Specialization": specialization,
        "DOB": dob,
        "email": email,
        "Phone": phoneNumber,
        "address": postalAddress
      });

      print(res);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
        return res as Response;
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> login(
    String email,
    String password,
  ) async {
    try {
      setLoading(true);
      print("Provier register");
      Response res = await http
          .post(Uri.parse("http://35.78.76.21:8000/subMatterEx/login"), body: {
        "email": email,
        "password": password,
      });

      print(res);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
      } else {
        print("Failure");
        print(res.body);

        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (e) {
      print(e);
    }
  }
}
