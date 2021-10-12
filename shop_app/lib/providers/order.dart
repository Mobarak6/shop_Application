import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/models/httpException.dart';
import 'package:shop_app/models/reloadingHandel.dart';

import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  int get len {
    return _items.length;
  }

  Future<void> addOrder(List<CartItem> products, double total, String? userId,
      String? idToken) async {
    final uri =
        'https://my-shop-backend-default-rtdb.firebaseio.com/orders/$userId.json?auth=$idToken';

    // final getUri = Uri.https(Model.url, '/orders.json');
    final getUri = Uri.parse(uri);
    try {
      DateTime timeStamp = DateTime.now();
      final responce = await http.post(getUri,
          body: json.encode({
            'amount': total,
            'products': products
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quentity': e.quentity,
                      'price': e.price,
                    })
                .toList(),
            'dateTime': timeStamp.toIso8601String(),
          }));
      _items.add(
        OrderItem(
          id: jsonDecode(responce.body)['name'],
          amount: total,
          products: products,
          dateTime: timeStamp,
        ),
      );
    } catch (e) {}

    //print('\nAddPrder: ${jsonDecode(responce.body)['name']}');

    notifyListeners();
  }

  Future<void> facthOrder(String? userId, String? idToken) async {
    List<OrderItem> initItems = [];
    if (ReloadingHandel.orderHandel) {
      final uri =
          'https://my-shop-backend-default-rtdb.firebaseio.com/orders/$userId.json?auth=$idToken';

      // final getUri = Uri.https(Model.url, '/orders.json');
      final getUri = Uri.parse(uri);

      try {
        final respoce = await http.get(getUri);
        var orderMap = jsonDecode(respoce.body) as Map<String, dynamic>;
        orderMap.forEach((id, value) {
          initItems.add(
            OrderItem(
              id: id.toString(),
              amount: value['amount'],
              products: (value['products'] as List<dynamic>)
                  .map((e) => CartItem(
                      id: e[id].toString(),
                      title: e['title'].toString(),
                      quentity: e['quentity'],
                      price: e['price']))
                  .toList(),
              dateTime: DateTime.parse(value['dateTime']),
            ),
          );
        });

        _items = initItems;
        ReloadingHandel.orderHandel = false;

        notifyListeners();
      } catch (e) {
        log(e.toString());
        throw HttpException(e.toString());
      }
    } else {
      return;
    }
  }
}
