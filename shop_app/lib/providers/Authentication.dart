import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import 'package:shop_app/models/httpException.dart' as ex;

import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  late String? idToken;
  late String? userId;
  DateTime? expDate;

  bool get isToken {
    return expDate == null || !expDate!.isAfter(DateTime.now()) ? false : true;
  }

  Future<void> authFunction(
      String email, String password, String linkType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$linkType?key=AIzaSyBMVomlNiTEjAO7ytQrPNng5lxAyFOKelg';
    var getUri = Uri.parse(url);
    final sharePref = await SharedPreferences.getInstance();

    try {
      final responce = await http.post(getUri,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      //log(jsonDecode(responce.body).toString());
      final responceData = jsonDecode(responce.body);
      expDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responceData['expiresIn']),
        ),
      );
      idToken = responceData['idToken'];
      userId = responceData['localId'];
      notifyListeners();

      final userSharePref = jsonEncode({
        'idToken': idToken,
        'userId': userId,
        'expDate': expDate!.toIso8601String(),
      });
      sharePref.setString('userSharePref', userSharePref);
    } catch (e) {
      throw ex.HttpException(e.toString());
    }
  }

  Future<bool> AutoLogin() async {
    // log('Auto login');
    //Future.delayed(Duration(milliseconds: 10));
    final sharePref = await SharedPreferences.getInstance();
    if (!sharePref.containsKey('userSharePref')) {
      return await false;
    }

    var getData = sharePref.getString('userSharePref');
    final mapData = jsonDecode(getData!);
    idToken = mapData['idToken'];
    userId = mapData['userId'];
    expDate = DateTime.parse(mapData['expDate']);
    log(expDate.toString());
    if (expDate!.isBefore(DateTime.now())) {
      logOut();
      return await false;
    }

    notifyListeners();
    sleep(Duration(seconds: 2));
    return await true;
  }

  Future<void> logOut() async {
    userId = null;
    idToken = null;
    expDate = null;
    final getPref = await SharedPreferences.getInstance();
    getPref.remove('userSharePref');
    //log('logOut done');
    notifyListeners();
  }
}
