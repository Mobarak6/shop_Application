import 'package:flutter/cupertino.dart';

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

  void addOrder(List<CartItem> products, double total) {
    _items.add(
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: products,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
