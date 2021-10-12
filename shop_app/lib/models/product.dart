import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/Authentication.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'Uri.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String? userId;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.userId,
    this.isFavorite = false,
  });
  void favoriteStatues(bool oldStatues) {
    isFavorite = oldStatues;
    notifyListeners();
  }

  Future<void> switchFavorit(Authentication auth, String productId) async {
    var oldStatues = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://my-shop-backend-default-rtdb.firebaseio.com/favouriteProduct/${auth.userId}.json?auth=${auth.idToken}';
    final getUri = Uri.parse(url);

    // final getUrl = Uri.https(Model.url, '/products/$id.json');
    try {
      final responce = await http.patch(getUri,
          body: json.encode({
            productId: isFavorite,
          }));

      if (responce.statusCode >= 400) {
        favoriteStatues(oldStatues);
      }
    } catch (exception) {
      favoriteStatues(oldStatues);
    }
  }
}
