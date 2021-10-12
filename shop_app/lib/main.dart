import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/Authentication.dart';

import 'package:shop_app/screens/logInScreen.dart';
import 'package:shop_app/screens/productDetailsPage.dart';
import 'package:shop_app/screens/shop_screen.dart';
import 'package:shop_app/screens/splashScreen.dart';
import '/providers/cart.dart';
import '/providers/order.dart';
import '/providers/products_provider.dart';
import '/screens/CartScreen.dart';
import '/screens/home_screen.dart';
import '/screens/order_screen.dart';
import '/screens/user_product_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Authentication(),
        ),
        ChangeNotifierProxyProvider<Authentication, Products>(
          create: (_) => Products(),
          update: (_, auth, preProducts) => preProducts!..facthData(auth),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: Consumer<Authentication>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop',
          theme: ThemeData(
            textTheme: TextTheme(
                headline6: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            )),
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: authData.isToken
              ? HomeScreenAll()
              : FutureBuilder(
                  future: authData.AutoLogin(),
                  builder: (context, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          // initialRoute:
          //     value.isToken ? ShopScreen.routeName : LoginScreen.routeName,
          routes: {
            HomeScreenAll.routeName: (context) => HomeScreenAll(),
            CartScreen.routeName: (context) => CartScreen(),
            UserProductForm.routeName: (context) => UserProductForm(),
            OrderScreen.routeName: (context) => OrderScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            ShopScreen.routeName: (context) => ShopScreen(),
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
          },
        ),
      ),
    );
  }
}
