import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  late String idToken;
  late String userId;
  DateTime? expDate;
  bool get isToken {
    return expDate == null || !expDate!.isAfter(DateTime.now()) ? false : true;
  }

  Future<void> authFunction(
      String email, String password, String linkType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$linkType?key=AIzaSyBMVomlNiTEjAO7ytQrPNng5lxAyFOKelg';
    var getUri = Uri.parse(url);

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
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }
}
