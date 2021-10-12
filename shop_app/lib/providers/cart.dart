import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/Uri.dart';
import 'package:shop_app/models/httpException.dart';

class CartItem {
  final String id;
  final String title;
  final int quentity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quentity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get Len {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quentity;
    });
    return total;
  }

  Future<void> addCart(
    String productId,
    String title,
    double price,
    String? userId,
    String? idToken,
  ) async {
    //final getUri = Uri.https(Model.url, '/Carts.json');

    if (_items.containsKey(productId)) {
      _items.forEach((key, value) async {
        final uri =
            'https://my-shop-backend-default-rtdb.firebaseio.com//Carts/$userId/${value.id}.json?auth=$idToken';

        final getUri = Uri.parse(uri);
        // final getUriCart = Uri.https(Model.url, '/Carts/${value.id}.json');
        await http.patch(getUri,
            body: jsonEncode({
              'quentity': value.quentity + 1,
            }));
      });

      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          quentity: value.quentity + 1,
          price: price,
        ),
      );
    } else {
      //final getUri = Uri.https(Model.url, '/Carts.json');
      final uri =
          'https://my-shop-backend-default-rtdb.firebaseio.com//Carts/$userId.json?auth=$idToken';

      final getUri = Uri.parse(uri);
      final responce = await http.post(getUri,
          body: jsonEncode({
            'title': title,
            'quentity': 1,
            'price': price,
          }));

      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: jsonDecode(responce.body)['name'],
          title: title,
          quentity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> facthCartItem(String? userId, String? idToken) async {
    Map<String, CartItem> _initItems = {};
    final uri =
        'https://my-shop-backend-default-rtdb.firebaseio.com//Carts/$userId.json?auth=$idToken';

    final getUri = Uri.parse(uri);
    final responce = await http.get(getUri);

    try {
      final itemMap = jsonDecode(responce.body) as Map<String, dynamic>;

      log(itemMap.toString());
      itemMap.forEach(
        (key, value) {
          var item = CartItem(
            id: key,
            title: value['title'],
            quentity: value['quentity'],
            price: value['price'],
          );
          _initItems.putIfAbsent(key, () => item);
        },
      );
      _items = _initItems;

      //log(_initItems.toString());

      notifyListeners();
    } catch (e) {}
  }

  void decreaseItem(String productId) {
    _items.update(
      productId,
      (value) => CartItem(
          id: value.id,
          title: value.title,
          quentity: value.quentity == 1 ? value.quentity : value.quentity - 1,
          price: value.price),
    );
    notifyListeners();
  }

  void incriseItem(String productId) {
    _items.update(
      productId,
      (value) => CartItem(
        id: value.id,
        title: value.title,
        quentity: value.quentity + 1,
        price: value.price,
      ),
    );
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    final getUri = Uri.https(Model.url, '/Carts/$productId.json');
    try {
      final respnce = await http.delete(getUri);
      if (respnce.statusCode > 400) {
        http.patch(getUri);
      } else {
        _items.remove(productId);
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> clear(String? userId, String? idToken) async {
    final uri =
        'https://my-shop-backend-default-rtdb.firebaseio.com//Carts/$userId.json?auth=$idToken';

    final getUri = Uri.parse(uri);
    // final getUri = Uri.https(Model.url, '/Carts.json');
    try {
      await http.delete(getUri);
      _items.clear();
      notifyListeners();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
