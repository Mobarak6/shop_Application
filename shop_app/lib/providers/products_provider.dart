import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/Uri.dart';
import 'package:shop_app/models/httpException.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/reloadingHandel.dart';
import 'package:shop_app/providers/Authentication.dart';

class Products with ChangeNotifier {
  List<Product> _DUMMY_ITEMS = [];

  // Products([required this.userToken, this._DUMMY_ITEMS]);

  List<Product> get DUMMY_ITEMS {
    return [..._DUMMY_ITEMS];
  }

  List<Product> get getFavorit {
    return _DUMMY_ITEMS.where((element) => element.isFavorite == true).toList();
  }

  Future<void> addItem(String getTitle, String getDescription, double getPrice,
      String getImageUrl, String? idToken, String? userId) {
    //final getUrl = Uri.https(Model.url, '/products.json');
    final url =
        "https://my-shop-backend-default-rtdb.firebaseio.com//products.json?auth=$idToken";
    final getUri = Uri.parse(url);

    return http
        .post(getUri,
            body: json.encode({
              'user': userId,
              'title': getTitle,
              'description': getDescription,
              'price': getPrice,
              'imageUrl': getImageUrl,
              //'isFavorit': false,
            }))
        .then((value) {
      Product product = Product(
        id: json.decode(value.body)['name'],
        userId: userId,
        title: getTitle,
        description: getDescription,
        price: getPrice,
        imageUrl: getImageUrl,
      );
      _DUMMY_ITEMS.add(product);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> facthData(
    Authentication auth,
  ) async {
    List<Product> _intProduct = [];

    // String filterHeader = filterBy ? "&orderBy='user'&equalTo'$userId" : '';
    // log(filterHeader);
    //  String bool = "true";
    final url =
        "https://my-shop-backend-default-rtdb.firebaseio.com/products.json?auth=${auth.idToken}";

    final getUri = await Uri.parse(url);
    //log(url);
    final furl =
        'https://my-shop-backend-default-rtdb.firebaseio.com/favouriteProduct/${auth.userId}.json?auth=${auth.idToken}';
    final geFevUri = await Uri.parse(furl);
    // log(furl);
    try {
      final responce = await http.get(getUri);
      final fevResponce = await http.get(geFevUri);
      final fevMap = jsonDecode(fevResponce.body); // as Map<String, bool>;

      var prodMap = json.decode(responce.body) as Map<String, dynamic>;
      // log(fevMap.toString());

      prodMap.forEach((proId, products) {
        // log((fevMap[proId] == null ? false : fevMap[proId] ?? false)
        //     .toString());

        _intProduct.add(Product(
          id: proId.toString(),
          title: products['title'],
          description: products['description'],
          price: products['price'],
          imageUrl: products['imageUrl'],
          userId: products['user'],
          isFavorite: fevMap == null
              ? false
              : fevMap[proId] == null
                  ? false
                  : fevMap[proId] ?? false,
        ));
        // print(product);

        _DUMMY_ITEMS = _intProduct;
        // ReloadingHandel.productHandel = false;
        notifyListeners();
      });
    } catch (error) {
      log(error.toString());
      throw error;
    }
  }

  Future<void> facthUserProduct(Authentication auth) async {
    List<Product> _intProduct = [];

    final url =
        'https://my-shop-backend-default-rtdb.firebaseio.com/products.json?auth=${auth.idToken}&orderBy="user"&equalTo="${auth.userId}"';

    final getUri = Uri.parse(url);
    try {
      final responce = await http.get(getUri);
      //log(idToken);
      //log(responce.body);
      var prodMap = json.decode(responce.body) as Map<String, dynamic>;
      prodMap.forEach((proId, products) {
        _intProduct.add(Product(
          id: proId.toString(),
          title: products['title'],
          description: products['description'],
          price: products['price'],
          imageUrl: products['imageUrl'],
          userId: products['user'],
        ));

        _DUMMY_ITEMS = _intProduct;
        ReloadingHandel.productHandel = false;
        notifyListeners();
      });
    } catch (error) {
      log(error.toString());
      throw error;
    }
  }

  Future<void> upDateItem(
      Authentication auth, String productId, Product newProduct) async {
    final url =
        'https://my-shop-backend-default-rtdb.firebaseio.com/products/$productId.json?auth=${auth.idToken}';
    final getUri = Uri.parse(url);
    try {
      // final getUrl = Uri.https(Model.url, '/products/$productId.json');

      await http.patch(
        getUri,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      ReloadingHandel.productHandel = true;

      // int getIndex =
      //     await _DUMMY_ITEMS.indexWhere((element) => element.id == productId);
      // _DUMMY_ITEMS[getIndex] = newProduct;

      //notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delItem(String productId, Authentication auth) async {
    final url =
        'https://my-shop-backend-default-rtdb.firebaseio.com/products/$productId.json?auth=${auth.idToken}';
    log(url);

    final getUri = Uri.parse(url);
    final res = await http.get(getUri);
    log(res.body.toString());
    // final getUrl = Uri.https(Model.url, '/products/$productId.json');
    int index = _DUMMY_ITEMS.indexWhere((element) => element.id == productId);
    Product? product = _DUMMY_ITEMS[index];

    var responce = await http.delete(getUri);
    if (responce.statusCode >= 400) {
      _DUMMY_ITEMS.insert(index, product);
      notifyListeners();

      throw HttpException('Something wrong...!!');
    }
    product = null;
    ReloadingHandel.productHandel = true;

    notifyListeners();
  }
}
