import 'package:flutter/material.dart';

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

  void addCart(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
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
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quentity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
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

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
